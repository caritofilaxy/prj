package SS::Schema::ResultSet::ExtraStopWord;

#===============================================================================
#     REVISION:  $Id: ExtraStopWord.pm 137 2011-12-13 17:06:47Z xdr.box@gmail.com $
#  DESCRIPTION:  Canned queries
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 137 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

use base qw(DBIx::Class::ResultSet);

sub get_extra_stop_words_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my @extra_stop_words
        = map { $_->word() } $self->search( { lang_id => $lang_id } );
    ### extra_stop_words: @extra_stop_words

    return \@extra_stop_words;
}

1;
