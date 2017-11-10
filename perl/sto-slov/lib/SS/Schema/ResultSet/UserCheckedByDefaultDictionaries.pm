package SS::Schema::ResultSet::UserCheckedByDefaultDictionaries;

#===============================================================================
#     REVISION:  $Id: UserCheckedByDefaultDictionaries.pm 136 2011-12-13 16:57:38Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 136 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub set_checked_by_default_flag {
    my $self               = shift;
    my $user_id            = shift;
    my $dict_id            = shift;
    my $checked_by_default = shift;

    my $row = $self->single( { user_id => $user_id, dict_id => $dict_id } );

    if ($row) {
        if ( $row->checked_by_default() != $checked_by_default ) {
            $row->checked_by_default($checked_by_default);
            $row->update();
        }

        return;
    }

    my $new_row = $self->new(
        {   user_id            => $user_id,
            dict_id            => $dict_id,
            checked_by_default => $checked_by_default,
        }
    );

    $new_row->insert();

    return;
}

1;
