package HTML::FormFu::Validator::SS::UserDoesntExist;

#===============================================================================
#     REVISION:  $Id: UserDoesntExist.pm 67 2011-10-21 11:55:56Z xdr.box@gmail.com $
#  DESCRIPTION:  Check that user doesn't exist yet
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 67 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(HTML::FormFu::Validator);

sub validate_value {
    my ( $self, $username, $params ) = @_;

    ### username: $username
    my $c = $self->form->stash->{context};

    my $user = $c->model('DB')->resultset('User')
        ->single( { username => $username } );

    return 1 if !$user;

    ## no critic (RequireCarping)
    die HTML::FormFu::Exception::Validator->new(
        {   message =>
                'Такой ник уже зарегистрирован!'
        }
    );
}

1;
