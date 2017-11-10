package SS::Tokenizer;

#===============================================================================
#     REVISION:  $Id: Tokenizer.pm 192 2012-01-10 22:36:13Z xdr.box@gmail.com $
#  DESCRIPTION:  Split subtitles into word, remove stop-words and short words,
#                count word frequencies, combine words with the same stem
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 192 $) [1];

use English qw( -no_match_vars );
use Params::Validate qw(:all);
use Lingua::StopWords qw( getStopWords );
use Lingua::Stem::Snowball;
use Carp;
use List::Util qw( reduce sum );
use List::MoreUtils qw( zip );

#use Smart::Comments;

use SS::Log;
use SS::LogParams;
use SS::Utils qw(
    dump_var
);
use SS::ParamsValidators qw(
    $VALIDATOR_LANG
    $VALIDATOR_ARRAYREF_DEFAULT_EMPTY
    $VALIDATOR_ARRAYREF
);

Readonly my %MIN_WORD_LENGTH_FOR => ( en => 3 );

sub new {
    my $class  = shift;
    my %params = validate(
        @_,
        {   lang             => $VALIDATOR_LANG,
            subtitles        => $VALIDATOR_ARRAYREF,
            extra_stop_words => $VALIDATOR_ARRAYREF_DEFAULT_EMPTY,
        }
    );

    my $self = {
        %params,
        logger => get_logger(),
        stats  => {
            subtitles_count             => 0,
            total_words_count           => 0,
            words_count_after_filtering => 0,
            words_count_after_stemming  => 0,
            stemming_ratio              => 0,
            biggest_stemmed_group       => [],
            biggest_stemmed_group_size  => 0,
            max_word_length             => 0,
            longest_word                => q{},
            max_word_frequency          => 0,
            most_frequent_word          => q{},
            stop_words_count            => 0,
            stop_words_skipped          => 0,
            short_words_skipped         => 0,
        }
    };

    return bless $self, $class;
}

sub get_words_frequencies {
    my $self = shift;

    my $logger = $self->{'logger'};

    if ( $self->{'words_frequencies'} ) {
        $logger->debug('Returning cached words frequencies');
        return $self->{'words_frequencies'};
    }

    $logger->debug('Calculating words frequencies...');

    my $frequency_of = {};

    my $subtitles    = $self->{'subtitles'};
    my $is_stop_word = $self->_get_stop_words();
    ### stop-words: $is_stop_word

    my $min_word_length = $MIN_WORD_LENGTH_FOR{ $self->{'lang'} };

    $self->{'stats'}{'subtitles_count'}  = scalar @{$subtitles};
    $self->{'stats'}{'stop_words_count'} = scalar keys %{$is_stop_word};

    foreach my $subtitle ( @{$subtitles} ) {
        my @words = map { lc $_ } split /\W+/xms, $subtitle;
        $self->{'stats'}{'total_words_count'} += scalar @words;

    WORD:
        foreach my $word (@words) {
            my $word_length = length $word;

            if ( $word_length < $min_word_length ) {
                $self->{'stats'}{'short_words_skipped'}++;
                ### short word: $word
                next WORD;
            }

            if ( $is_stop_word->{$word} ) {
                $self->{'stats'}{'stop_words_skipped'}++;
                ### stop-word: $word
                next WORD;
            }

            $frequency_of->{$word} ||= 0;
            $frequency_of->{$word}++;

            if ( $word_length > $self->{'stats'}{'max_word_length'} ) {
                $self->{'stats'}{'max_word_length'} = $word_length;
                $self->{'stats'}{'longest_word'}    = $word;
            }

            if ( $frequency_of->{$word}
                > $self->{'stats'}{'max_word_frequency'} )
            {
                $self->{'stats'}{'max_word_frequency'}
                    = $frequency_of->{$word};
                $self->{'stats'}{'most_frequent_word'} = $word;
            }
        }
    }

    $self->{'stats'}{'words_count_after_filtering'}
        = scalar keys %{$frequency_of};

    $frequency_of = $self->_join_words_with_the_same_stem($frequency_of);

    $self->{'stats'}{'words_count_after_stemming'}
        = scalar keys %{$frequency_of};

    if ( $self->{'stats'}{'words_count_after_stemming'} != 0 ) {
        $self->{'stats'}{'stemming_ratio'} = sprintf '%.2f',
            $self->{'stats'}{'words_count_after_filtering'}
            / $self->{'stats'}{'words_count_after_stemming'};
    }

    $logger->debug(
        'Tokenizer statistics: ' . dump_var( $self->get_stats(), 'STATS' ) );
    $self->{'words_frequencies'} = $frequency_of;

    return $self->{'words_frequencies'};
}

sub get_stats {
    my $self = shift;

    return $self->{'stats'};
}

sub _get_stop_words {
    my $self = shift;

    my $default_stop_words = getStopWords( $self->{'lang'} );
    my $extra_stop_words
        = { map { lc $_ => 1 } @{ $self->{'extra_stop_words'} } };

    return { %{$default_stop_words}, %{$extra_stop_words} };
}

sub _join_words_with_the_same_stem {
    my $self         = shift;
    my $frequency_of = shift;

    my $stemmer = Lingua::Stem::Snowball->new( lang => $self->{'lang'} );

    if ($EVAL_ERROR) {
        confess "Cannot create stemmer ($self->{'lang'}): $EVAL_ERROR";
    }

    my @words = keys %{$frequency_of};
    my @stems = $stemmer->stem( \@words );

    if ( @words != @stems ) {
        confess 'Number of words ('
            . scalar @words
            . ') and number of stems ('
            . scalar @stems
            . ') differs';
    }

    my %stem_of = zip @words, @stems;
    my %words_group_with = ();

    while ( my ( $word, $frequency ) = each %{$frequency_of} ) {
        my $stem = $stem_of{$word};

        $words_group_with{$stem} ||= [];
        push @{ $words_group_with{$stem} },
            { word => $word, frequency => $frequency };
    }
    ### words_group_with: %words_group_with

    my %joined_frequency_of = ();
    while ( my ( $stem, $words_group ) = each %words_group_with ) {
        my ( $word, $frequency ) = $self->_join_words_group($words_group);
        $joined_frequency_of{$word} = $frequency;
    }

    return \%joined_frequency_of;
}

sub _join_words_group {
    my $self        = shift;
    my $words_group = shift;

    my $frequency_sum = sum map { $_->{'frequency'} } @{$words_group};

    my $most_frequent_word = reduce {
              $a->{'frequency'} > $b->{'frequency'}     ? $a
            : $a->{'frequency'} < $b->{'frequency'}     ? $b
            : length $a->{'word'} < length $b->{'word'} ? $a
            :                                             $b;
    }
    @{$words_group};

    if ( @{$words_group} > $self->{'stats'}{'biggest_stemmed_group_size'} ) {
        $self->{'stats'}{'biggest_stemmed_group_size'}
            = scalar @{$words_group};
        $self->{'stats'}{'biggest_stemmed_group'}
            = [ sort map { $_->{'word'} } @{$words_group} ];
    }

    return ( $most_frequent_word->{'word'}, $frequency_sum );
}

1;
