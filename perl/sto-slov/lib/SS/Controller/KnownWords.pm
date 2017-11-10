package SS::Controller::KnownWords;

#===============================================================================
#     REVISION:  $Id: KnownWords.pm 197 2012-01-11 19:35:00Z xdr.box@gmail.com $
#  DESCRIPTION:  Known words - browse/add/delete known words
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use Moose;
use namespace::autoclean;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 197 $) [1];

use English qw( -no_match_vars );

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

__PACKAGE__->config( namespace => 'known_words' );

use SS::Helpers qw(
    redirect_to
    session_set_cur_lang
    n_slov
    get_form_errors
);
use SS::Log;

sub _get_known_words {
    my ( $self, $c ) = @_;

    return $c->user()
        ->get_known_words_with_ids_for_lang_id(
        $c->session->{'cur_lang'}{'id'} );
}

sub _populate_show_all_form {
    my ( $self, $c, $form, $lang ) = @_;

    $form->action("/known_words/show_all/$lang");
    $self->_populate_known_word_ids_element( $c, $form, $lang );

    return;
}

sub _populate_known_word_ids_element {
    my ( $self, $c, $form, $lang ) = @_;

    my $element           = $form->get_element( name => 'known_word_ids' );
    my $known_words       = $self->_get_known_words($c);
    my $known_words_count = scalar @{$known_words};

    my @options = map { { value => $_->{'id'}, label => $_->{'word'} } }
        @{$known_words};

    # Append number of known_words to the label
    my $label = $element->label();
    $label =~ s/:\z//xms;
    ## no critic (ProhibitParensWithBuiltins)
    $element->label( sprintf( '%s (%d):', $label, $known_words_count ) );

    my $logger = get_logger();
    $logger->debug("Known words count for '$lang' lang: $known_words_count");

    $element->options( \@options );

    return;
}

sub show_all : Local : FormConfig : Args(1) {
    my ( $self, $c, $lang ) = @_;

    return if not session_set_cur_lang( $c, $lang );

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $known_word_ids = $form->param_array('known_word_ids');
        my $words_deleted  = $c->user()->delete_known_words($known_word_ids);

        $logger->debug(
            "Known words deleted for '$lang' lang: $words_deleted");

        redirect_to(
            context    => $c,
            uri_for    => "/known_words/show_all/$lang",
            status_msg => 'Удалено ' . n_slov($words_deleted),
        );

        return;
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    $self->_populate_show_all_form( $c, $form, $lang );

    return;
}

__PACKAGE__->meta->make_immutable;

1;
