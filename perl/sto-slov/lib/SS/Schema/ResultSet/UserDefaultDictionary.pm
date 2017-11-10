package SS::Schema::ResultSet::UserDefaultDictionary;

#===============================================================================
#     REVISION:  $Id: UserDefaultDictionary.pm 135 2011-12-13 10:23:19Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 135 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub set_default_dict_id {
    my $self    = shift;
    my $user_id = shift;
    my $lang_id = shift;
    my $dict_id = shift;

    my $row = $self->single(
        {   user_id => $user_id,
            lang_id => $lang_id,
        }
    );

    if ($row) {
        if ( $row->dict_id() != $dict_id ) {
            $row->dict_id($dict_id);
            $row->update();
        }

        return;
    }

    my $new_row = $self->new(
        {   user_id => $user_id,
            lang_id => $lang_id,
            dict_id => $dict_id,
        }
    );

    $new_row->insert();

    return;
}

1;
