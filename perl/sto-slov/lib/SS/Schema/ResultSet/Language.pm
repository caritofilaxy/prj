package SS::Schema::ResultSet::Language;

#===============================================================================
#     REVISION:  $Id: Language.pm 111 2011-12-09 12:45:05Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 111 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub get_lang_by_code {
    my $self = shift;

    my %all_langs
        = map { $_->code() => { id => $_->id(), name => $_->name() } }
        $self->all();
    ### all_langs: %all_langs

    return \%all_langs;
}

1;
