#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_test.t 158 2012-01-04 20:52:38Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::Test :)
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 158 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;
#$ENV{'DONT_CLEANUP'} = 1;

use Test::More tests => 7;
use SS::Test qw(
    init_test_environment
);

sub test_init_test_environment {
    my $tmp_dir = init_test_environment();

    ok( -d $tmp_dir,             "Check tmp dir '$tmp_dir' is created" );
    ok( -d "$tmp_dir/subtitles", 'Check subtitles dir is created' );
    ok( -f "$tmp_dir/ss.db",     'Check DB is created' );

    my $lang_count
        = `sqlite3 '$tmp_dir/ss.db' 'select count(*) from languages' 2>&1`;
    chomp $lang_count;
    is( $lang_count, 1, 'Check record count in languages table' );

    ok( -f "$tmp_dir/ss.log4perl", 'Check Log4Perl config is created' );
    ok( -f "$tmp_dir/ss.log",      'Check log file is created' );
    ok( -f "$tmp_dir/ss.perl",     'Check application config is created' );

    return;
}

sub run_tests {
    test_init_test_environment();

    return;
}

run_tests();
