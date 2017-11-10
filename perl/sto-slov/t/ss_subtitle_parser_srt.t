#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_subtitle_parser_srt.t 32 2011-10-10 14:03:58Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::Subtitle::Parser::SRT
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 32 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use SS::Subtitle::ParserFactory;
use SS::Test qw(
    get_subtitle_path
);
use SS::Utils qw(
    dump_compact
);

use Test::More;
use Test::Exception;

Readonly my $EXTRA_TESTS => 0;

Readonly my @TEST_CASES => (
    {   input_params => {
            file_name => get_subtitle_path('The_Big_Lebowsky_part_en.srt'),
            max_size  => 0,
            max_subtitles => 0,
        },
        expected_result => {
            subtitles => [
                'They pee on your fucking rug.',
                'They pee on my fucking rug.',
                'That\'s right, Dude.',
                'They peed on your fucking rug.',
                'This is the study.',
                'As you can see, the various commendations...',
                '"Jeffrey Lebowski."',
                'Honorary degrees, etcetera.',
                'very impressive.',
                'Oh, please feel free to inspect them.',
            ],
        },
    },

    {   input_params => {
            file_name     => get_subtitle_path('no_such_file.srt'),
            max_size      => 0,
            max_subtitles => 0,
        },
        expected_result => {
            exception_re => qr{\QCannot open '\E .* /no_such_file[.]srt'}xms,
            why          => 'no such file',
        },
    },

    {   input_params => {
            file_name => get_subtitle_path('The_Big_Lebowsky_part_en.srt'),
            max_size  => 669,
            max_subtitles => 0,
        },
        expected_result => {
            ## no critic (ProhibitComplexRegexes)
            exception_re => qr{
                \QSize of '\E
                .*
                \Q/The_Big_Lebowsky_part_en.srt' (670) exceeds limit (669)\E
            }xms,
            why => 'max file size limit exceeded',
        },
    },

    {   input_params => {

            # UNIX end-of-line
            file_name =>
                get_subtitle_path('The_Big_Lebowsky_damaged_part_en.srt'),
            max_size      => 706,    # exact size
            max_subtitles => 10,     # last subtile should be skipped
        },
        expected_result => {
            subtitles => [
                'They pee on your fucking rug.',
                'They pee on my fucking rug.',
                'That\'s right, Dude.',
                'They peed on your fucking rug.',
                'This is the study (STARTING AND TRAILING SPACES HERE).',
                'As you can see, the various commendations...',
                'Honorary degrees, etcetera.',
            ],
        },
    },

    {   input_params => {
            file_name     => get_subtitle_path('random_data.srt'),
            max_size      => 0,
            max_subtitles => 0,
        },
        expected_result => {
            subtitles =>
                ['The only correct subtitle in randomly generated file.'],
        },
    },

    {   input_params => {
            file_name =>
                get_subtitle_path('Kung_Fu_Panda_2_html_part_en.srt'),
            max_size      => 0,
            max_subtitles => 0,
        },
        expected_result => {
            subtitles => [
                'Long ago, in ancient China.',
                'The Peacocks rueld over Gongmen city.',
                'They brought great joy, and prosperity to the city.',

                # not balanced tag </i>
                'A panda, stands between you and your destiny !',
                'Sub and Timing by: Ballen Abdulkarim Ema!l: Ballen.kurdistan@yahoo.com',
                'www.moviesubtitles.org',
            ],
        },
    },

    {   input_params => {
            file_name     => get_subtitle_path('empty_file.srt'),
            max_size      => 0,
            max_subtitles => 0,
        },
        expected_result => { subtitles => [] },
    },
);

sub set_test_plan {
    plan tests => $EXTRA_TESTS + scalar @TEST_CASES;

    return;
}

sub test_common_cases {
    foreach my $test_case (@TEST_CASES) {
        my $test_params
            = dump_compact( $test_case->{'input_params'}, 'PARAMS' );

        if ( $test_case->{'expected_result'}{'subtitles'} ) {
            my $parser = SS::Subtitle::ParserFactory->create(
                %{ $test_case->{'input_params'} } );

            my $got_subtitles;

            $got_subtitles = $parser->extract_subtitles();
            $got_subtitles = $parser->extract_subtitles();    # test cache
            ### got_subtitles: $got_subtitles

            my $expected_subtitles
                = $test_case->{'expected_result'}{'subtitles'};

            is_deeply( $got_subtitles, $expected_subtitles,
                "Check extracted subtitles: $test_params" );
        }
        else {
            my $exception_re
                = $test_case->{'expected_result'}{'exception_re'};
            my $why = $test_case->{'expected_result'}{'why'};

            throws_ok {
                my $parser = SS::Subtitle::ParserFactory->create(
                    %{ $test_case->{'input_params'} } );
                $parser->extract_subtitles();
            }
            $exception_re,
                "Check that subtitle extraction failed ($why): $test_params";
        }
    }

    return;
}

sub run_tests {
    set_test_plan();
    test_common_cases();

    return;
}

run_tests();
