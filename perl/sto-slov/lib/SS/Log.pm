package SS::Log;

#===============================================================================
#      REVISION:  $Id: Log.pm 194 2012-01-11 00:00:32Z xdr.box@gmail.com $
#   DESCRIPTION:  Logging wrapper around Log::Log4perl
#        AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 194 $) [1];

use English qw( -no_match_vars );
use Carp;
use Log::Log4perl;
use Params::Validate qw(:all);
use File::Basename;

#use Smart::Comments;

use base qw(Exporter);

our @EXPORT = qw(get_logger);    ## no critic (ProhibitAutomaticExportation)
our %EXPORT_TAGS = ( all => [qw(get_logger init_logger)] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );

Readonly my $DEFAULT_LOG4PERL_CONFIG => "$ENV{'SS_ROOT'}/conf/log4perl.conf";
Readonly my $DEFAULT_LOG4PERL_DELAY => 0;    # don't reread config by default

# Directory for application-specific configs
Readonly my $LOG4PERL_D => "$ENV{'SS_ROOT'}/conf/log4perl.d";

Readonly my $LOG_TO_SCREEN => <<'END_CONFIG';
    conversion_pattern = [%d{yyyy-MM-dd HH:mm:ss}] [%p] [%X{username}] [%X{action}] %M(%L): %m%n

    log4perl.rootlogger = DEBUG, Screen
    log4perl.appender.Screen = Log::Log4perl::Appender::ScreenColoredLevels
    log4perl.appender.Screen.layout = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = ${conversion_pattern}
END_CONFIG

Readonly my $LOG_TO_NOWHERE => <<'END_CONFIG';
    log4perl.rootlogger = DEBUG, devnull
    log4perl.appender.devnull = Log::Dispatch::File
    log4perl.appender.devnull.filename = /dev/null
    log4perl.appender.devnull.layout = Log::Log4perl::Layout::SimpleLayout
END_CONFIG

Readonly my %LOG_TO => (
    SCREEN  => $LOG_TO_SCREEN,
    NOWHERE => $LOG_TO_NOWHERE,
);

sub init_logger {
    my %params = validate(
        @_,
        {   config => {
                default => $ENV{'LOG4PERL_CONFIG'}
                    || _get_app_specific_config()
                    || $DEFAULT_LOG4PERL_CONFIG,
                regex => qr/\A.+\z/xms,
            },
            delay => {
                default => $ENV{'LOG4PERL_DELAY'} || $DEFAULT_LOG4PERL_DELAY,
                regex => qr/\A\d+\z/xms,
            },
            log_to => {
                default   => undef,
                callbacks => {
                    'config and delay parameters are not set' => sub {
                        return $_[1]->{'config'} || $_[1]->{'delay'} ? 0 : 1;
                    },
                    'value is legal' => sub {
                        return scalar grep { $_[0] eq $_ } keys %LOG_TO;
                    },
                }
            }
        }
    );

    ### $ENV{'LOG4PERL_CONFIG'}: $ENV{'LOG4PERL_CONFIG'}
    ### $ENV{'LOG4PERL_DELAY'}: $ENV{'LOG4PERL_DELAY'}
    ### params: %params

    return if Log::Log4perl->initialized();

    ### Initializing Log4perl...

    if ( $params{'log_to'} ) {
        Log::Log4perl->init( \$LOG_TO{ $params{'log_to'} } );

        return;
    }

    eval {
        if ( $params{'delay'} )
        {
            Log::Log4perl->init_and_watch( $params{'config'},
                $params{'delay'} );
        }
        else {
            Log::Log4perl->init( $params{'config'} );
        }
    };

    if ($EVAL_ERROR) {
        if ( $ENV{'HARNESS_ACTIVE'} ) {
            my Readonly $LOG_TO_THERE
                = $ENV{'TEST_VERBOSE'} ? $LOG_TO_SCREEN : $LOG_TO_NOWHERE;

            Log::Log4perl->init( \$LOG_TO_THERE );
        }
        else {
            carp "Cannot initialize Log4perl: $EVAL_ERROR";
            Log::Log4perl->init( \$LOG_TO_SCREEN );
        }
    }

    return;
}

sub get_logger {
    my $category = shift;
    my $caller_depth = shift || 0;

    if ( !defined $category ) {
        $category = ( caller $caller_depth )[0];    # undef = caller's package
    }
    ### Logging category: $category

    if ( !Log::Log4perl->initialized() ) {
        init_logger();
    }

    my $logger = Log::Log4perl->get_logger($category);

    if ( !$logger ) {
        croak "Cannot get logger for category '$category'";
    }

    return $logger;
}

sub _get_app_specific_config {
    ## no critic (RequireExtendedFormatting, RequireLineBoundaryMatching, RequireDotMatchAnything)
    my $config
        = $LOG4PERL_D . q{/}
        . fileparse( $PROGRAM_NAME, qr/[.](?:t|pl)$/ )
        . q{.conf};

    ### application specific config: $config

    return -e $config ? $config : undef;
}

1;
