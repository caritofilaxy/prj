#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_tokenizer.t 32 2011-10-10 14:03:58Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::Tokenizer
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 32 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use SS::Tokenizer;
use SS::Subtitle::ParserFactory;

use SS::Test qw(
    get_subtitle_path
);

use SS::Utils qw(
    dump_compact
);

use Test::More;

Readonly my $EXTRA_TESTS => 1;

Readonly my @TEST_CASES => (

    {   input_params => {
            lang      => 'en',
            subtitles => [
                'They fly and fly on your quirking rug.',
                'It flies and flies on my quirked rug.',
                'That\'s right, flying Dude.',
                'They flied on your quirking rug.',
                'This is the study (about your rug).',
                '"Jeffrey Lebowski."',
            ],
            extra_stop_words => [ 'Lebowski', 'Jeffrey', 'FooBar' ],
        },
        expected_result => {
            dude     => '1',
            quirking => '3',
            fly      => '6',
            right    => '1',
            rug      => '4',
            study    => '1',
        },
        test_label => 'Common case',
    },

    {   input_params => {
            lang      => 'en',
            subtitles => [],
        },
        expected_result => {},
        test_label      => 'No subtitles passed',
    },

    {   input_params => {
            lang      => 'en',
            subtitles => [
                'xx',                        # short word
                'the',                       # stop-word
                'tHis_sHouLd_Be_SkIpPeD',    # extra stop-word
                ',/., /.',                   # non word chars
            ],
            extra_stop_words => ['THIS_SHOULD_BE_SKIPPED'],  # will be lc()-ed
        },
        expected_result => {},
        test_label      => 'Subtitles passed but all words should be ignored',
    },
);

sub set_test_plan {
    plan tests => $EXTRA_TESTS + scalar @TEST_CASES;

    return;
}

# This test is useful for benchmarking Tokenizer and
# getting stats from real life data. This tests also
# covers some parts of code that other tests don't cover
sub test_on_real_file {
    my $parser = SS::Subtitle::ParserFactory->create(
        file_name     => get_subtitle_path('The_Big_Lebowsky_full_en.srt'),
        max_size      => 0,
        max_subtitles => 0,
    );

    my $subtitles = $parser->extract_subtitles();

    my $tokenizer
        = SS::Tokenizer->new( lang => 'en', subtitles => $subtitles );
    my $words_frequencies = $tokenizer->get_words_frequencies();

    my $got_stats = $tokenizer->get_stats();

    Readonly my @SKIP_FIELDS => qw(
        short_words_skipped
        stemming_ratio
        stop_words_count
        stop_words_skipped
        total_words_count
        words_count_after_filtering
        words_count_after_stemming
    );

    foreach my $skip_field (@SKIP_FIELDS) {
        delete $got_stats->{$skip_field};
    }

    my $expected_stats = {
        biggest_stemmed_group =>
            [ 'achieve', 'achieved', 'achievement', 'achiever', 'achievers' ],
        biggest_stemmed_group_size => '5',
        longest_word               => 'administration',
        max_word_frequency         => '180',
        max_word_length            => '14',
        most_frequent_word         => 'man',
        subtitles_count            => '2234',
    };

    is_deeply( $got_stats, $expected_stats,
        'Check Tokenizer stats on real life data' );

    return;
}

sub test_common_cases {
    foreach my $test_case (@TEST_CASES) {
        my $tokenizer
            = SS::Tokenizer->new( %{ $test_case->{'input_params'} } );

        my $got;
        $got = $tokenizer->get_words_frequencies();
        $got = $tokenizer->get_words_frequencies();    # cache test

        ### got: $got
        my $expected = $test_case->{'expected_result'};

        is_deeply( $got, $expected, $test_case->{'test_label'} );
    }

    return;
}

sub run_tests {
    set_test_plan();
    test_common_cases();
    test_on_real_file();

    return;
}

run_tests();
