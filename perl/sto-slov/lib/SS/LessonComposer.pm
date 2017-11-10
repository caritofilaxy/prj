package SS::LessonComposer;

#===============================================================================
#     REVISION:  $Id: LessonComposer.pm 192 2012-01-10 22:36:13Z xdr.box@gmail.com $
#  DESCRIPTION:  Pick N most frequent words, excluding those the person already knows.
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 192 $) [1];

use English qw( -no_match_vars );
use Params::Validate qw(:all);
use Carp;

#use Smart::Comments;

use SS::Log;
use SS::Utils qw(
    dump_var
);

use SS::ParamsValidators qw(
    $VALIDATOR_UNSIGNED_INTEGER
    $VALIDATOR_ARRAYREF_DEFAULT_EMPTY
);

Readonly my $DEFAULT_LESSON_LIMIT => 100;    # Sto slov!

sub new {
    my $class = shift;

    my %params = validate(
        @_,
        {   words_frequencies => { type => HASHREF() },
            known_words  => $VALIDATOR_ARRAYREF_DEFAULT_EMPTY,
            lesson_limit => {
                %{$VALIDATOR_UNSIGNED_INTEGER},
                default => $DEFAULT_LESSON_LIMIT,
            },
        }
    );

    my $self = {
        %params,
        logger => get_logger(),
        stats  => {
            total_words_passed         => 0,
            known_words_passed         => 0,
            known_words_skipped        => 0,
            unknown_words_remain       => 0,
            lesson_coverage_percentage => 0,
        },
    };

    return bless $self, $class;
}

sub compose {
    my $self = shift;

    my $logger = $self->{'logger'};

    if ( $self->{'lesson'} ) {
        $logger->debug('Returning cached lesson');
        return $self->{'lesson'};
    }

    $logger->debug('Composing a lesson...');

    my %is_known = map { lc $_ => 1 } @{ $self->{'known_words'} };
    $self->{'stats'}{'known_words_passed'}
        = scalar @{ $self->{'known_words'} };

    my @unknown_words = grep { !$is_known{ lc $_ } }
        keys %{ $self->{'words_frequencies'} };

    my $frequency_of = $self->{'words_frequencies'};
    $self->{'stats'}{'total_words_passed'} = scalar keys %{$frequency_of};
    $self->{'stats'}{'known_words_skipped'}
        = $self->{'stats'}{'total_words_passed'} - scalar @unknown_words;

    # most frequent - first, if frequencies are equal - shortest first
    # Rationale: short words are used more often, that's why they
    # worth learning more then long words
    ## no critic (ProhibitReverseSortBlock)
    @unknown_words = map { lc $_ } sort {
        $frequency_of->{$b} <=> $frequency_of->{$a}
            || length $a <=> length $b
    } @unknown_words;

    my $lesson_limit        = $self->{'lesson_limit'};
    my $unknown_words_count = scalar @unknown_words;

    $self->{'lesson'}
        = $lesson_limit == 0                    ? \@unknown_words
        : $lesson_limit >= $unknown_words_count ? \@unknown_words
        :   [ @unknown_words[ 0 .. $lesson_limit - 1 ] ];

    $self->{'stats'}{'unknown_words_remain'} = scalar @{ $self->{'lesson'} };

    $self->{'stats'}{'lesson_coverage_percentage'}
        = _compute_lesson_coverage_percentage(
        $self->{'stats'}{'total_words_passed'},
        $self->{'stats'}{'known_words_skipped'},
        $self->{'stats'}{'unknown_words_remain'},
        );

    $logger->debug( 'LessonComposer statistics: '
            . dump_var( $self->get_stats(), 'STATS' ) );

    return $self->{'lesson'};
}

sub get_stats {
    my $self = shift;

    return $self->{'stats'};
}

sub _compute_lesson_coverage_percentage {
    my $total_words_passed   = shift;
    my $known_words_skipped  = shift;
    my $unknown_words_remain = shift;

    ## no critic (ProhibitMagicNumbers)
    my $unknown_words_passed = $total_words_passed - $known_words_skipped;

    Readonly my $FORMAT => '%.2f';
    if ( $unknown_words_passed == 0 ) {
        return sprintf $FORMAT, 100;
    }

    return sprintf $FORMAT,
        100 * $unknown_words_remain / $unknown_words_passed;
}

1;
