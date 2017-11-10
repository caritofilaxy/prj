package SS::Schema::ResultSet::UserLessonLimit;

#===============================================================================
#     REVISION:  $Id: UserLessonLimit.pm 126 2011-12-09 17:26:50Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 126 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub set_lesson_limit {
    my $self         = shift;
    my $user_id      = shift;
    my $lang_id      = shift;
    my $lesson_limit = shift;

    my $row = $self->single(
        {   user_id => $user_id,
            lang_id => $lang_id,
        }
    );

    if ($row) {
        if ( $row->lesson_limit() != $lesson_limit ) {
            $row->lesson_limit($lesson_limit);
            $row->update();
        }

        return;
    }

    my $new_row = $self->new(
        {   user_id      => $user_id,
            lang_id      => $lang_id,
            lesson_limit => $lesson_limit,
        }
    );

    $new_row->insert();

    return;
}

1;
