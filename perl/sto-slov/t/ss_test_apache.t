#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: ss_test_apache.t 198 2012-01-12 21:03:30Z xdr.box@gmail.com $
#  DESCRIPTION:  Test for SS::Test::Apache
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 198 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use Test::More tests => 1;

use SS::Test::Apache;

sub run_tests {
    my $apache = SS::Test::Apache->run();

    ok( $apache, 'Start apache instance' );

    return;
}

run_tests();
