package SS::Helpers;

#===============================================================================
#     REVISION:  $Id: Helpers.pm 197 2012-01-11 19:35:00Z xdr.box@gmail.com $
#  DESCRIPTION:  Helper methods
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 197 $) [1];

use Params::Validate qw(:all);
use Perl6::Junction qw( any );
use Lingua::RU::Numeric::Declension qw( numdecl );

#use Smart::Comments;

use base qw(Exporter);

our @EXPORT_OK = qw(
    redirect_to
    session_set_cur_lang
    n_slov
    n_minut
    get_form_errors
);

use SS::ParamsValidators qw(
    $VALIDATOR_CONTEXT
);

sub redirect_to {
    my %params = validate(
        @_,
        {   context    => $VALIDATOR_CONTEXT,
            uri_for    => { default => q{/} },
            status_msg => 0,
            error_msg  => 0,
        }
    );

    my $c = $params{'context'};

    $c->response->redirect(
        $c->uri_for(
            $params{'uri_for'},
            $params{'status_msg'}
            ? { mid => $c->set_status_msg( $params{'status_msg'} ) }
            : $params{'error_msg'}
            ? { mid => $c->set_error_msg( $params{'error_msg'} ) }
            : ()
        )
    );

    return;
}

sub session_set_cur_lang {
    my $c    = shift;
    my $lang = shift;

    if ( !$c->session->{'lang_by_code'} ) {
        _session_set_lang_by_code($c);
    }

    if ( !_is_lang_supported( $c, $lang ) ) {
        redirect_to(
            context => $c,
            error_msg =>
                'Печально, но данный язык не поддерживается'
        );

        return 0;
    }

    $c->session(
        cur_lang => {
            code => $lang,
            id   => $c->session->{'lang_by_code'}{$lang}{'id'},
            name => $c->session->{'lang_by_code'}{$lang}{'name'},
        },
    );

    return 1;
}

sub n_slov {
    my $number = shift;

    return "$number "
        . numdecl( $number, 'слово', 'слова', 'слов' );
}

sub n_minut {
    my $number = shift;

    return "$number "
        . numdecl( $number, 'минута', 'минуты', 'минут' );
}

sub _session_set_lang_by_code {
    my $c = shift;

    $c->session(
        lang_by_code => $c->model('DB::Language')->get_lang_by_code() );

    return;
}

sub _is_lang_supported {
    my $c    = shift;
    my $lang = shift;

    my @all_langs = keys %{ $c->session->{'lang_by_code'} };

    return any(@all_langs) eq $lang ? 1 : 0;
}

sub get_form_errors {
    my $form = shift;

    my $form_errors = q{};

    ## no critic (ProhibitParensWithBuiltins, ProhibitInterpolationOfLiterals)
    if ( $form->has_errors() ) {
        my $form_id = $form->id();
        my $field_errors = join q{; }, map {
            sprintf( "%s: '%s' %s failed (%s)",
                $_->name(), $_->type, $_->stage(), $_->message() )
        } @{ $form->get_errors() };

        $form_errors = "$form_id errors: $field_errors";
    }

    return $form_errors;
}

1;
