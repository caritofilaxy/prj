package SS::LogParams;

#===============================================================================
#     REVISION:  $Id: LogParams.pm 5 2011-09-06 11:37:41Z xdr.box@gmail.com $
#  DESCRIPTION:  Automatic params and result logging
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#         NOTE:  An interesting fact: this module uses four (!) modules
#                written by Damian Conway:
#                - Hook::LexWrap
#                - Smart::Comments
#                - Regexp::Common
#                - Readonly
#
#  LIMITATIONS:  1. SS::LogParams doesn't work with require
#
#                Attribute :Log is processed at CHECK phase but
#                this phase is skipped for require()d modules.
#                So, if you require() module with functions marked
#                using :Log attribute this attribute will be ignored.
#
#                2. SS::LogParams doesn't work with Exporter
#
#                The Exporter module injects function names into caller's
#                namespace BEFORE SS::LogParams (actually Hook::LexWrap)
#                wraps them into params- and result-logging hooks.
#
#                SS::LogParams can be used either for object/class methods
#                or fully qualified function names (i.e. including package name)
#
#                3. Result won't be logged if the function is called in void context
#
#                This is due to Hook::LexWrap's implementation. E.g.:
#
#                sub foo : Log {
#                    return 123;
#                }
#
#                ...
#
#                foo();         # result '123' will NOT be logged, void context
#                my $x = foo(); # result '123' will be logged
#
#                If result is not interesting, set :Log( result => 0 )
#
#         TODO:  add filter_params => {1|0} option
#                add filter_result => {1|0} option
#
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 5 $) [1];

use English qw( -no_match_vars );
use Attribute::Handlers;
use Hook::LexWrap;
use Data::Dumper;
use Params::Validate qw(:all);
use Module::Loaded;
use Log::Log4perl::Level;
use List::MoreUtils qw(any);

#use Smart::Comments;

my $CALL_DEPTH;

BEGIN {
    ## no critic (Capitalization)
    Readonly $CALL_DEPTH => is_loaded('SS::Log') ? 2 : 1;
    ### CALL_DEPTH: $CALL_DEPTH
}

use SS::Log;
use SS::Regexp qw($FLAG_01_RE);
use SS::ParamsValidators qw(
    $VALIDATOR_UNSIGNED_INTEGER
);

Readonly my $EMPTY_STR               => q{};
Readonly my $DEFAULT_MAX_DUMP_LENGTH => 8 * 1024;

# Mapping from level names to Log4perl's level constants
Readonly my %LEVEL_OF => (
    DEBUG => $DEBUG,
    INFO  => $INFO,
    WARN  => $WARN,
    ERROR => $ERROR,
    FATAL => $FATAL,
);

sub UNIVERSAL::Log : ATTR(CODE)    ## no critic (Capitalization)
{    ## no critic (ProhibitManyArgs, ProhibitMixedCaseSubs)
    my $package  = shift;
    my $symbol   = shift;
    my $referent = shift;
    my $args     = shift;
    my $data     = shift;
    my $phase    = shift;
    my $filename = shift;
    my $linenum  = shift;

    my @raw_params = _extract_params_from_attr_data($data);
    my %params     = validate(
        @raw_params,
        {   params         => { default  => 1, regex => $FLAG_01_RE },
            result         => { default  => 1, regex => $FLAG_01_RE },
            params_as_hash => { default  => 1, regex => $FLAG_01_RE },
            self           => { default  => 0, regex => $FLAG_01_RE },
            category       => { optional => 1, type  => SCALAR() },
            level          => {
                default   => 'DEBUG',
                callbacks => {
                    'is valid' => sub {
                        any { $_ eq $_[0] } qw(DEBUG INFO WARN ERROR FATAL);
                    },
                },
            },
            max_dump_length => {
                %{$VALIDATOR_UNSIGNED_INTEGER},
                default => $DEFAULT_MAX_DUMP_LENGTH,
            },
        }
    );
    ### params: %params

    # Neither params no result logging was requsted
    return if !$params{'params'} && !$params{'result'};

    my $log_params = _make_log_params_subref( \%params, $package, $symbol );
    my $log_result = _make_log_result_subref( \%params, $package, $symbol );

    wrap $symbol,
        $params{'params'} ? ( pre  => $log_params ) : (),
        $params{'result'} ? ( post => $log_result ) : ();

    return;
}

sub _extract_params_from_attr_data {
    my $data = shift;

    ### raw attr data: $data
    return () if !defined $data;
    return ($data) if ref $data eq $EMPTY_STR;
    return @{$data};
}

sub _stringify_complex_refs {
    my @args = @_;

    return map { _is_simple_ref_or_scalar($_) ? $_ : "$_" } @args;
}

sub _is_simple_ref_or_scalar {
    my $ref = shift;

    return _is_simple_ref($ref) ? 1 : ( ref $ref eq $EMPTY_STR ? 1 : 0 );
}

sub _is_simple_ref {
    my $ref = shift;

    return
          ref $ref eq 'ARRAY'  ? 1
        : ref $ref eq 'HASH'   ? 1
        : ref $ref eq 'SCALAR' ? 1
        :                        0;
}

sub _is_method_call {
    my $self_or_class = shift;
    my $package       = shift;

    ### self_or_class: $self_or_class
    ### package: $package
    return 0 if !defined $self_or_class;
    return 0 if _is_simple_ref($self_or_class);
    return ref $self_or_class
        ? ( $self_or_class->isa($package) ? 1 : 0 )
        : ( $self_or_class eq $package ? 1 : 0 );
}

sub _make_log_params_subref {
    my $params  = shift;
    my $package = shift;
    my $symbol  = shift;

    my $subref = sub {
        my @args = @_;
        ### args before stringification: @args

        pop @args;    # last item is internal Hook::LexWrap's placeholder
        @args = _stringify_complex_refs(@args);

        my $full_name = $package . q{::} . *{$symbol}{NAME};

        my $logger = get_logger( $params->{'category'} || $package );
        local $Log::Log4perl::caller_depth
            = $Log::Log4perl::caller_depth + $CALL_DEPTH;

        my @dump_items  = ();
        my @dump_labels = ();

        if ( _is_method_call( $_[0], $package ) ) {
            my $self = shift @args;

            if ( $params->{'self'} ) {
                push @dump_items,  $self;
                push @dump_labels, 'SELF';
            }
        }

        if ( @args % 2 == 0 && $params->{'params_as_hash'} ) {
            push @dump_items, {@args};
        }
        else {
            push @dump_items, \@args;

            if ( $params->{'params_as_hash'} ) {
                $logger->warn(
                    qq{Subroutine '$full_name' is called with odd number of params }
                        . q{while :Log( params_as_hash => 1 ). }
                        . q{Please either set :Log( params_as_hash => 0 ) or check your params list}
                );
            }
        }

        push @dump_labels, 'PARAMS';
        my $dump = _create_dump( [@dump_items], [@dump_labels],
            $params->{'max_dump_length'} );

        $logger->log( $LEVEL_OF{ $params->{'level'} },
            "$full_name(): $dump" );

        return;
    };

    return $subref;
}

sub _make_log_result_subref {
    my $params  = shift;
    my $package = shift;
    my $symbol  = shift;

    my $subref = sub {
        my $result    = $_[-1];
        my $full_name = $package . q{::} . *{$symbol}{NAME};

        my $logger = get_logger( $params->{'category'} || $package );
        local $Log::Log4perl::caller_depth
            = $Log::Log4perl::caller_depth + $CALL_DEPTH;

        if ( ref $result eq 'Hook::LexWrap::Cleanup' ) {
            $logger->warn(
                qq{Subroutine '$full_name' is called in void context while :Log( result => 1 ). }
                    . q{Please either set :Log ( result => 0 ) or store returned value}
            );

            return;
        }

        if ( !_is_simple_ref_or_scalar($result) ) {
            $result = "$result";
        }

        my $dump = _create_dump( [$result], ['RESULT'],
            $params->{'max_dump_length'} );

        $logger->log( $LEVEL_OF{ $params->{'level'} },
            "$full_name(): $dump" );

        return;
    };

    return $subref;
}

sub _create_dump {
    my $dump_items      = shift;
    my $dump_labels     = shift;
    my $max_dump_length = shift;

    my $dumper = Data::Dumper->new( $dump_items, $dump_labels );

    $dumper->Sortkeys(1);
    my $dump = $dumper->Dump();

    if ( length $dump > $max_dump_length ) {
        $dump = ( substr $dump, 0, $max_dump_length ) . q{ [TRUNCATED]...};
    }

    return $dump;
}

1;
