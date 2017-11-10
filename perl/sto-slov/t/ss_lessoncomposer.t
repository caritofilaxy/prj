#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_lessoncomposer.t 99 2011-11-01 15:35:28Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::LessonComposer
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 99 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use SS::LessonComposer;

use Test::More;

Readonly my $EXTRA_TESTS => 0;
Readonly my @TEST_CASES  => (
    {   input_params => {
            words_frequencies => {
                DUDE     => '1',
                quirking => '3',
                fly      => '6',
                right    => '1',
                rug      => '4',
                study    => '1',
            },
            known_words  => [ 'QuIrKiNg', 'study', ],
            lesson_limit => 3,
        },
        expected_result => [ 'fly', 'rug', 'dude' ],
        expected_stats  => {
            total_words_passed         => 6,
            known_words_passed         => 2,
            known_words_skipped        => 2,
            unknown_words_remain       => 3,
            lesson_coverage_percentage => '75.00',    # 3/4
        },
        test_label => 'Common case',
    },
    {   input_params    => { words_frequencies => {}, lesson_limit => 0, },
        expected_result => [],
        expected_stats  => {
            total_words_passed         => 0,
            known_words_passed         => 0,
            known_words_skipped        => 0,
            unknown_words_remain       => 0,
            lesson_coverage_percentage => '100.00',    # all of nothing
        },
        test_label => 'Everything is empty',
    },
    {   input_params => {
            words_frequencies => {
                aaa => '10',
                bbb => '5',
                ccc => '1',
            },
            known_words  => [ 'ddd', 'eee', ],
            lesson_limit => 10,
        },
        expected_result => [ 'aaa', 'bbb', 'ccc' ],
        expected_stats  => {
            total_words_passed         => 3,
            known_words_passed         => 2,
            known_words_skipped        => 0,
            unknown_words_remain       => 3,
            lesson_coverage_percentage => '100.00',
        },
        test_label => 'Lesson limit is larger then word set',
    },
);

sub test_common_cases {
    foreach my $test_case (@TEST_CASES) {
        my $composer
            = SS::LessonComposer->new( %{ $test_case->{'input_params'} } );
        my $got_result = $composer->compose();
        $got_result = $composer->compose();    # from cache
        my $expected_result = $test_case->{'expected_result'};

        is_deeply( $got_result, $expected_result,
            "$test_case->{'test_label'} [check words]" );

        my $got_stats      = $composer->get_stats();
        my $expected_stats = $test_case->{'expected_stats'};

        is_deeply( $got_stats, $expected_stats,
            "$test_case->{'test_label'} [check stats]" );
    }

    return;
}

sub set_test_plan {
    plan tests => $EXTRA_TESTS + 2 * scalar @TEST_CASES;

    return;
}

sub run_tests {
    set_test_plan();

    test_common_cases();

    return;
}

run_tests();
