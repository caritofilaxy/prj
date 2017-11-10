package SS::Controller::Root;

#===============================================================================
#     REVISION:  $Id: Root.pm 197 2012-01-11 19:35:00Z xdr.box@gmail.com $
#  DESCRIPTION:  Root controller
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use Moose;
use namespace::autoclean;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 197 $) [1];

BEGIN { extends 'Catalyst::Controller' }

# Sets the actions in this controller to be registered with no prefix
__PACKAGE__->config( namespace => q{} );

use SS::Helpers qw(
    redirect_to
);
use SS::Log;
use Log::Log4perl;

# By default all actions require auth, but there are some exceptions:
Readonly my %AUTH_IS_PROHIBITED_FOR => map { $_ => 1 } qw(
    user/login
    user/register
);

Readonly my %AUTH_IS_OPTIONAL_FOR => map { $_ => 1 } qw(
    index
    default
    lesson/start
    lesson/translate_word
    lesson/finish
);

sub _auth_is_prohibited_for : Private {
    my $action = shift;

    return $AUTH_IS_PROHIBITED_FOR{$action} ? 1 : 0;
}

sub _auth_is_required_for : Private {
    my $action = shift;

    return $AUTH_IS_OPTIONAL_FOR{$action}
        || $AUTH_IS_PROHIBITED_FOR{$action} ? 0 : 1;
}

sub auto : Private {
    my ( $self, $c ) = @_;

    $c->load_status_msgs();

    my $logger = get_logger();

    my $action = $c->action();
    my $username
        = $c->user_exists() ? $c->user()->username() : $c->req->address();

    Log::Log4perl::MDC->put( 'username', $username );
    Log::Log4perl::MDC->put( 'action',   $action );

    if ( $action !~ m{\Alesson/.+}xms && $c->session->{'lesson'} ) {
        $logger->warn('Aborting current lesson');
        $c->session( lesson => undef );
    }

    if ( $c->user_exists() ) {
        $c->stash(
            user_obj => $c->model('DB::User')->find( $c->user()->id() ) );

        if ( _auth_is_prohibited_for($action) ) {
            $logger->warn('Auth is prohibited');

            redirect_to(
                context   => $c,
                error_msg => "Вы уже вошли как $username",
            );

            return 0;
        }
    }
    else {
        if ( _auth_is_required_for($action) ) {
            $logger->warn('Auth is required');

            redirect_to(
                uri_for => '/user/login',
                context => $c,
                error_msg =>
                    'Вы ещё не вошли либо ваша сессия безнадёжно устарела!',
            );

            return 0;
        }
    }

    return 1;
}

sub index : Path : Args(0) {    ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    $logger->debug('Welcome!');

    $c->stash( template => 'welcome.tt2' );

    return;
}

sub default : Path {            ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;

    my $uri    = $c->request->uri();
    my $logger = get_logger();

    $logger->warn("Page not found: '$uri'");

    $c->response->body('Page not found');
    $c->response->status(404);    ## no critic (ProhibitMagicNumbers)

    return;
}

sub end : ActionClass('RenderView') {

}

__PACKAGE__->meta->make_immutable;

1;
