package SS::Schema::ResultSet::Dictionary;

#===============================================================================
#     REVISION:  $Id: Dictionary.pm 123 2011-12-09 17:01:17Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 123 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub get_dicts_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my @dicts = $self->search(
        { lang_id  => $lang_id, hidden => 0 },
        { order_by => ['priority'] }
    );

    return \@dicts;
}

1;
