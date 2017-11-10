#!/usr/bin/perl

#===============================================================================
#     REVISION:  $Id: live-www-common-case.t 199 2012-01-12 21:07:15Z xdr.box@gmail.com $
#  DESCRIPTION:  Live WWW test: common-case usage scenario
#     ENV VARS:  - NUMBER_OF_USERS
#                - DONT_CLEANUP
#                - CATALYST_SERVER
#         NOTE:
#                If CATALYST_SERVER = 'http://localhost:<port>' than local
#                temporary Apache2/mod_perl instance will be configured and started
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 199 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

Readonly my $EXTRA_TESTS     => 0;
Readonly my $TESTS_PER_USER  => 94;
Readonly my $NUMBER_OF_USERS => $ENV{'NUMBER_OF_USERS'} || 10;

use Test::More;

use SS::Test qw(
    init_test_environment
);
use SS::Test::Apache;

use FindBin qw($Bin);
FindBin::again();

use lib "$Bin/live-www-common-case/lib";
use SS::Test::User;

sub test_common_case {
    my @user_sessions = ();
    foreach my $number ( 1 .. $NUMBER_OF_USERS ) {
        push @user_sessions,
            {
            user  => SS::Test::User->new( number => $number ),
            steps => [
                'go_to_welcome_page',
                'start_lesson_anonymous',
                'translate_few_words_anonymous',
                'finish_lesson_anonymous',
                'go_to_welcome_page',
                'register_account',
                'login',
                'start_lesson_auth_first_time',
                'translate_few_words_auth_first_time',
                'finish_lesson_auth_first_time',
                'start_lesson_auth_second_time',
                'translate_few_words_auth_second_time',
                'finish_lesson_auth_second_time',
                'manage_known_words',
                'change_email',
                'change_password',
                'logout',
                'login_with_new_password',
                'remove_account',
            ],
            };
    }

    my $steps_left
        = $NUMBER_OF_USERS * scalar @{ $user_sessions[0]->{'steps'} };

    # shuffle user activity to make test more realistic
USER_SESSION:
    while ( $steps_left > 0 ) {
        my $user_session = $user_sessions[ int rand $NUMBER_OF_USERS ];

        if ( !@{ $user_session->{'steps'} } ) {
            next USER_SESSION;
        }

        my $user = $user_session->{'user'};
        my $step = shift @{ $user_session->{'steps'} };

        $user->$step();
        $steps_left--;
    }

    return;
}

sub set_test_plan {
    plan tests => $TESTS_PER_USER * $NUMBER_OF_USERS + $EXTRA_TESTS;

    return;
}

sub run_tests {
    set_test_plan();

    my $tmp_dir = init_test_environment();
    note("tmp_dir: $tmp_dir");

    my $apache;
    if (    $ENV{'CATALYST_SERVER'}
        and $ENV{'CATALYST_SERVER'} =~ m{\Ahttp://localhost:(\d+)}xms )
    {
        my $port = $1;
        $apache = SS::Test::Apache->run( port => $port );
        note( 'Apache server_root=' . $apache->get_server_root() );
    }

    test_common_case();

    return;
}

run_tests();
