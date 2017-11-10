package SS::Controller::User;

#===============================================================================
#     REVISION:  $Id: User.pm 197 2012-01-11 19:35:00Z xdr.box@gmail.com $
#  DESCRIPTION:  User controller: register, login, logout, delete, etc.
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use Moose;
use namespace::autoclean;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 197 $) [1];

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

use SS::Form::Constraint;
use SS::Helpers qw(
    redirect_to
    get_form_errors
);
use SS::Log;

sub index : Path : Args(0) {    ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    $logger->debug('My account page');

    # use default template
    return;
}

sub login : Local : FormConfig : Args(0) {
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $username = $form->param_value('username');
        my $password = $form->param_value('password');

        my $auth_okay = $c->authenticate(
            {   username => $username,
                password => $password,
            }
        );

        if ($auth_okay) {
            $logger->info("Logged in as '$username'");
            redirect_to(
                context    => $c,
                status_msg => "Добро пожаловать, $username!",
            );

            return;
        }
        else {
            $logger->warn( "Failed to login as '$username': "
                    . 'no such account or bad password' );
            $c->stash( error_msg => 'Хм, у нас таких нет' );

            return;
        }
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    return;
}

sub logout : Local : Args(0) {
    my ( $self, $c ) = @_;

    my $logger   = get_logger();
    my $username = $c->user()->username();

    $c->logout();
    $logger->info('Logged out');

    redirect_to(
        context    => $c,
        status_msg => "Ждём вас снова, $username!",
    );

    return;
}

sub register : Local : FormConfig : Args(0) {
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $new_user = $c->model('DB::User')->new_result( {} );

        $form->model->update($new_user);

        my $username = $new_user->username();
        $logger->info("New account '$username' is created");

        redirect_to(
            uri_for => '/user/login',
            context => $c,
            status_msg =>
                "Отлично $username, теперь входите!",
        );

        return;
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    return;
}

sub remove : Local : FormConfig : Args(0) {
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        $c->user()->delete();
        $c->logout();

        $logger->info('Account is removed');

        redirect_to(
            context    => $c,
            status_msg => 'Ваш аккаунт удалён. Совсем.',
        );

        return;
    }

    return;
}

sub change_password : Local : FormConfig : Args(0) {
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $user_obj = $c->stash->{'user_obj'};

        $form->model->update($user_obj);
        $logger->info('Password changed successfully');

        redirect_to(
            uri_for    => '/user/change_password',
            context    => $c,
            status_msg => 'Пароль успешно изменён',
        );

        return;
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    return;
}

sub change_email : Local : FormConfig : Args(0) {
    my ( $self, $c ) = @_;

    my $logger   = get_logger();
    my $form     = $c->stash->{'form'};
    my $user_obj = $c->stash->{'user_obj'};

    if ( $form->submitted_and_valid() ) {
        $form->model->update($user_obj);
        $logger->info('Email changed successfully');

        redirect_to(
            uri_for    => '/user/change_email',
            context    => $c,
            status_msg => 'Email успешно изменён',
        );

        return;
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    $form->model->default_values($user_obj);

    return;
}

__PACKAGE__->meta->make_immutable;

1;
