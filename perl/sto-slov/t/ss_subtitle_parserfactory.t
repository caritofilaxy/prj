#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_subtitle_parserfactory.t 32 2011-10-10 14:03:58Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::Subtitle::ParserFactory
#         NOTE:  This test script checks only failed cases, successful
#                cases are checked by test scripts like ss_subtitle_parser_XYZ.t
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 32 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use SS::Subtitle::ParserFactory;
use SS::Test;

use Test::More tests => 2;
use Test::Exception;

sub run_tests {
    ## no critic (ProhibitMagicNumbers)
    my $file_without_extension = '/no/extension_here';
    throws_ok {
        SS::Subtitle::ParserFactory->create(
            file_name     => $file_without_extension,
            max_size      => 10 * 1024 * 1024,
            max_subtitles => 10_000,
        );
    }
    qr{\QCannot find extension of '$file_without_extension'\E}xms,
        "Check file without extension '$file_without_extension'";

    my $file_with_unsupported_extension = 'The Big Lebowsky.XYZ';
    throws_ok {
        SS::Subtitle::ParserFactory->create(
            file_name     => $file_with_unsupported_extension,
            max_size      => 10 * 1024 * 1024,
            max_subtitles => 10_000,
        );
    }
    qr{\QCannot find parser for '.xyz' subtitle format\E}xms,
        "Check file with unsupported extension '$file_with_unsupported_extension'";

    return;
}

run_tests();
