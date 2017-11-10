package SS::Controller::Lesson;

#===============================================================================
#     REVISION:  $Id: Lesson.pm 206 2012-03-11 13:27:19Z xdr.box@gmail.com $
#  DESCRIPTION:  Lesson controller - core part of the application's UI
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use Moose;
use namespace::autoclean;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 206 $) [1];

use English qw( -no_match_vars );
use List::MoreUtils qw( first_value );
use File::Temp qw( tempfile );
use Fatal qw( close );
use Params::Validate qw(:all);

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

use SS::Form::Constraint;
use SS::Helpers qw(
    redirect_to
    session_set_cur_lang
    n_slov
    n_minut
    get_form_errors
);
use SS::ParamsValidators qw(
    $VALIDATOR_NOT_EMPTY
    $VALIDATOR_LANG
    $VALIDATOR_UNSIGNED_INTEGER
    $VALIDATOR_ARRAYREF_DEFAULT_EMPTY
    $VALIDATOR_CONTEXT
);
use SS::Subtitle::ParserFactory;
use SS::Tokenizer;
use SS::LessonComposer;
use SS::Log;

sub _session_set_dicts_for_cur_lang {
    my ( $self, $c ) = @_;

    my $dicts_for_cur_lang = $c->model('DB::Dictionary')
        ->get_dicts_for_lang_id( $c->session->{'cur_lang'}{'id'} );

    $c->session( dicts_for_cur_lang => $dicts_for_cur_lang );

    return;
}

sub _get_lesson_limit {
    my ( $self, $c ) = @_;

    return if !$c->user_exists();

    return $c->user()
        ->get_lesson_limit_for_lang_id( $c->session->{'cur_lang'}{'id'} );
}

sub _get_extra_stop_words {
    my ( $self, $c ) = @_;

    return $c->model('DB::ExtraStopword')
        ->get_extra_stop_words_for_lang_id( $c->session->{'cur_lang'}{'id'} );
}

sub _get_known_words {
    my ( $self, $c ) = @_;

    return [] if !$c->user_exists();

    return $c->user()
        ->get_known_words_for_lang_id( $c->session->{'cur_lang'}{'id'} );
}

sub _get_default_dict_id {
    my ( $self, $c ) = @_;

    return if !$c->user_exists();

    return $c->user()
        ->get_default_dict_id_for_lang_id( $c->session->{'cur_lang'}{'id'} );
}

sub _populate_start_lesson_form {
    my ( $self, $c, $form, $lang ) = @_;

    $form->action("/lesson/start/$lang");

    $self->_populate_dictionary_id_list_element( $c, $form );
    $self->_populate_default_dictionary_id_element( $c, $form );
    $self->_populate_lesson_limit_element( $c, $form );
    $self->_populate_save_my_preferences_element( $c, $form );

    return;
}

sub _get_combined_is_checked_by_default {
    my ( $self, $c ) = @_;

    # system-wide 'is_checked_by_default'
    my %is_checked_by_default = map { $_->id() => $_->checked_by_default() }
        @{ $c->session->{'dicts_for_cur_lang'} };

    return \%is_checked_by_default if not $c->user_exists();

    # user-wide 'is_checked_by_default' (override system settings)
    my @user_dicts = $c->user()->users_checked_by_default_dictionaries();
    foreach my $d (@user_dicts) {
        $is_checked_by_default{ $d->dict_id() } = $d->checked_by_default();
    }

    return \%is_checked_by_default;
}

sub _populate_dictionary_id_list_element {
    my ( $self, $c, $form ) = @_;

    my $element = $form->get_element( name => 'dictionary_id_list' );
    my $is_checked_by_default
        = $self->_get_combined_is_checked_by_default($c);

    my @options = map {
        {   value      => $_->id(),
            label      => $_->description() . ' [' . $_->type()->type() . ']',
            attributes => {
                $is_checked_by_default->{ $_->id() }
                ? ( checked => 'checked' )
                : ()
            },
        }
    } @{ $c->session->{'dicts_for_cur_lang'} };

    $element->options( \@options );

    return;
}

sub _get_first_dict_id_checked_by_default {
    my ( $self, $c ) = @_;

    return if !$c->user_exists();

    my $dict = first_value { $_->checked_by_default() ? 1 : 0 }
    @{ $c->session->{'dicts_for_cur_lang'} };

    return if !$dict;
    return $dict->id();
}

sub _get_combined_default_dict_id {
    my ( $self, $c ) = @_;

    my $dict_id;

    $dict_id = $self->_get_default_dict_id($c);
    return $dict_id if defined $dict_id;

    $dict_id = $self->_get_first_dict_id_checked_by_default($c);
    return $dict_id if defined $dict_id;

    return;
}

sub _populate_default_dictionary_id_element {
    my ( $self, $c, $form ) = @_;

    my $element = $form->get_element( name => 'default_dictionary_id' );

    my @options = map {
        {   value => $_->id(),
            label => $_->description() . ' [' . $_->type()->type() . ']',
        }
    } @{ $c->session->{'dicts_for_cur_lang'} };

    my $dict_id = $self->_get_combined_default_dict_id($c);

    if ( defined $dict_id ) {
        my $option = first_value { $_->{'value'} == $dict_id } @options;

        if ($option) {
            $option->{'attributes'} = { selected => 'selected' };
        }
    }

    $element->options( \@options );

    return;
}

sub _populate_lesson_limit_element {
    my ( $self, $c, $form ) = @_;

    my $lesson_limit = $self->_get_lesson_limit($c);
    return if !defined $lesson_limit;

    my $element = $form->get_element( name => 'lesson_limit' );
    $element->value($lesson_limit);

    return;
}

sub _populate_save_my_preferences_element {
    my ( $self, $c, $form ) = @_;

    my $element = $form->get_element( name => 'save_my_preferences' );

    if ( $c->user_exists() ) {
        $element->attributes( { checked => 'checked' } );
    }
    else {
        my $label = $element->label();
        $label =~ s/:\z//xms;
        $element->label(
            "$label (а что, отличный повод зарегистрироваться на сайте!):"
        );
        $element->attributes( { disabled => 'disabled' } );
    }

    return;
}

sub _save_subtitle_file {
    my ( $self, $c, $subtitle_file ) = @_;

    my $logger = get_logger();

    my $subtitles_dir = $c->config->{'subtitles'}{'dir'};
    my ( $fh, $file_name ) = tempfile(
        'subtitle-XXXXXX',
        SUFFIX => '.srt',    # NOTE: at the moment only .srt is supported
        (   $subtitles_dir
            ? ( DIR => $subtitles_dir )
            : ( TMPDIR => 1 )
        ),
        UNLINK => 0,
    );

    my $data = $subtitle_file->slurp();
    print {$fh} $data;
    close $fh;

    $logger->debug("Subtitle file is saved to '$file_name'");

    return $file_name;
}

sub _compose_lesson {
    my $self = shift;

    my %params = validate(
        @_,
        {   context          => $VALIDATOR_CONTEXT,
            file_name        => $VALIDATOR_NOT_EMPTY,
            lesson_limit     => $VALIDATOR_UNSIGNED_INTEGER,
            lang             => $VALIDATOR_LANG,
            extra_stop_words => $VALIDATOR_ARRAYREF_DEFAULT_EMPTY,
            known_words      => $VALIDATOR_ARRAYREF_DEFAULT_EMPTY,
        }
    );

    my $config = $params{'context'}->config();
    my $parser = SS::Subtitle::ParserFactory->create(
        file_name     => $params{'file_name'},
        max_size      => $config->{'subtitles'}{'max_size'},
        max_subtitles => $config->{'subtitles'}{'max_subtitles'},
    );

    my $subtitles = $parser->extract_subtitles();

    my $tokenizer = SS::Tokenizer->new(
        lang             => $params{'lang'},
        subtitles        => $subtitles,
        extra_stop_words => $params{'extra_stop_words'},
    );

    my $words_frequencies = $tokenizer->get_words_frequencies();

    my $lesson_composer = SS::LessonComposer->new(
        words_frequencies => $words_frequencies,
        known_words       => $params{'known_words'},
        lesson_limit      => $params{'lesson_limit'},
    );

    my $lesson_words = $lesson_composer->compose();

    my $lesson = {
        words                   => $lesson_words,
        is_added_to_known_words => {},
        words_count             => scalar @{$lesson_words},
        frequency_of            => $words_frequencies,
        tokenizer_stats         => $tokenizer->get_stats(),
        lesson_composer_stats   => $lesson_composer->get_stats(),
        lang                    => $params{'lang'},
        file_name               => $params{'file_name'},
        start_time              => time,
    };

    return $lesson;
}

sub _get_selected_dicts {
    my ( $self, $c, $selected_dict_ids, $default_dict_id ) = @_;

    my @dicts = @{ $c->session->{'dicts_for_cur_lang'} };
    my %is_selected = map { $_ => 1 } @{$selected_dict_ids};

    # Map dictionary IDs into dictionary objects, put default
    # dictionary first, while keeping order of other dictionaries
    my @selected_dicts = (
        ( first_value { $_->id() == $default_dict_id } @dicts ),
        (   grep {
                $is_selected{ $_->id() }
                    && ( $_->id() != $default_dict_id )
                } @dicts
        )
    );

    return \@selected_dicts;
}

sub _save_selected_dicts {
    my ( $self, $c, $selected_dict_ids ) = @_;

    my $user_id = $c->user->id();
    my @dict_ids = map { $_->id() } @{ $c->session->{'dicts_for_cur_lang'} };
    my %is_selected = map { $_ => 1 } @{$selected_dict_ids};

    my $db = $c->model('DB::UserCheckedByDefaultDictionaries');

    foreach my $dict_id (@dict_ids) {
        my $checked_by_default = $is_selected{$dict_id} ? 1 : 0;

        $db->set_checked_by_default_flag( $user_id, $dict_id,
            $checked_by_default );
    }

    return;
}

sub _save_lesson_limit {
    my ( $self, $c, $lesson_limit ) = @_;

    my $user_id = $c->user->id();
    my $lang_id = $c->session->{'cur_lang'}{'id'};

    $c->model('DB::UserLessonLimit')
        ->set_lesson_limit( $user_id, $lang_id, $lesson_limit );

    return;
}

sub _save_default_dict {
    my ( $self, $c, $dict_id ) = @_;

    my $user_id = $c->user->id();
    my $lang_id = $c->session->{'cur_lang'}{'id'};

    $c->model('DB::UserDefaultDictionary')
        ->set_default_dict_id( $user_id, $lang_id, $dict_id );

    return;
}

sub _save_preferences_if_required {
    my ( $self, $c, $form ) = @_;

    return if !$c->user_exists();

    my $save_my_preferences = $form->param_value('save_my_preferences');

    if ( !$save_my_preferences ) {
        my $logger = get_logger();
        $logger->debug('Not saving preferences');

        return;
    }

    $self->_save_lesson_limit( $c, $form->param_value('lesson_limit') );
    $self->_save_default_dict( $c,
        $form->param_value('default_dictionary_id') );
    $self->_save_selected_dicts( $c,
        $form->param_array('dictionary_id_list') );

    return;
}

sub _check_word_number {
    my ( $self, $c, $word_number, $words_count ) = @_;

    my $logger = get_logger();

    if (   $word_number !~ /\A\d+\z/xms
        || $word_number < 1
        || $word_number > $words_count )
    {
        $logger->warn("Invalid word number: '$word_number'");

        redirect_to(
            context => $c,
            error_msg =>
                'Номер слова не соответствует установленному формату '
                . 'либо выходит за допустимый диапазон. Так не пойдёт.',
        );

        return 0;
    }

    return 1;
}

sub start : Local : FormConfig : Args(1) {
    my ( $self, $c, $lang ) = @_;

    return if not session_set_cur_lang( $c, $lang );

    $self->_session_set_dicts_for_cur_lang($c);

    my $logger = get_logger();
    my $form   = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        $self->_save_preferences_if_required( $c, $form );

        my $file_name
            = $self->_save_subtitle_file( $c, $form->param('subtitle_file') );

        my $lesson = eval {
            $self->_compose_lesson(
                context          => $c,
                file_name        => $file_name,
                lesson_limit     => $form->param('lesson_limit'),
                lang             => $lang,
                extra_stop_words => $self->_get_extra_stop_words($c),
                known_words      => $self->_get_known_words($c),
            );
        };

        if ($EVAL_ERROR) {
            $logger->error("Failed to compose lesson: $EVAL_ERROR");

            redirect_to(
                context => $c,
                error_msg =>
                    'Возникла досадная ошибка, урок отменяется',
            );

            return;
        }

        if ( $lesson->{'tokenizer_stats'}{'subtitles_count'} == 0 ) {
            $logger->warn('No subtitles found in the file');

            redirect_to(
                context => $c,
                error_msg =>
                    'В загруженном файле нет субтитров!'
            );

            return;
        }

        if ( $lesson->{'words_count'} == 0 ) {
            $logger->warn('Empty lesson!');

            redirect_to(
                context => $c,
                status_msg =>
                    'В загруженном файле не оказалось незнакомых вам слов'
            );

            return;
        }

        my $selected_dicts = $self->_get_selected_dicts(
            $c,
            $form->param_array('dictionary_id_list'),
            $form->param_value('default_dictionary_id')
        );

        $c->session(
            lesson         => $lesson,
            selected_dicts => $selected_dicts,
        );

        $logger->info('Lesson successfully composed');
        $c->response->redirect('/lesson/translate_word/1');

        return;
    }

    if ( $form->has_errors() ) {
        $logger->warn( get_form_errors($form) );
    }

    $self->_populate_start_lesson_form( $c, $form, $lang );

    return;
}

sub translate_word : Local : Args(1) {
    my ( $self, $c, $word_number ) = @_;

    my $logger = get_logger();
    my $lesson = $c->session->{'lesson'};

    if ( !$lesson ) {
        $logger->warn('Attempt to proceed with non-existent lesson');

        redirect_to(
            context => $c,
            error_msg =>
                'Урок не найден или уже закончился! '
                . 'Но не отчаивайтесь, всегда можно начать новый.',
        );

        return;
    }

    my $words_count = $lesson->{'words_count'};
    return if not $self->_check_word_number( $c, $word_number, $words_count );

    my $word_index = $word_number - 1;

    my $words        = $lesson->{'words'};
    my $frequency_of = $lesson->{'frequency_of'};

    my $word      = $words->[$word_index];
    my $frequency = $frequency_of->{$word};

    $c->stash(
        word                    => $word,
        is_added_to_known_words => $lesson->{'is_added_to_known_words'},
        words                   => $words,
        frequency_of            => $frequency_of,
        current_word_number     => $word_number,
        next_word_number        => (
              ( $word_number + 1 <= $words_count )
            ? ( $word_number + 1 )
            : undef
        ),
        prev_word_number =>
            ( ( $word_number - 1 >= 1 ) ? ( $word_number - 1 ) : undef ),
        dictionaries => $c->session->{'selected_dicts'},
        title        => "$word ($frequency) $word_number/$words_count",
    );

    $logger->debug("Translate '$word' $word_number/$words_count");

    return;
}

sub finish : Local : Args(0) {
    my ( $self, $c ) = @_;

    my $logger = get_logger();
    my $lesson = $c->session->{'lesson'};

    if ( !$lesson ) {
        $logger->warn('Attempt to finish already finished lesson');
        redirect_to( context => $c );

        return;
    }

    $c->session->{'lesson'} = undef;

    my $tokenizer_stats       = $lesson->{'tokenizer_stats'};
    my $lesson_composer_stats = $lesson->{'lesson_composer_stats'};

    my $start_time = $lesson->{'start_time'};
    my $end_time   = time;

    ## no critic (ProhibitMagicNumbers)
    my $lesson_duration_minutes = int( ( $end_time - $start_time ) / 60 );
    my $lesson_duration
        = $lesson_duration_minutes == 0
        ? 'Меньше минуты!'
        : n_minut($lesson_duration_minutes);
    ## use critic

    my $learned_words_count
        = scalar keys %{ $lesson->{'is_added_to_known_words'} };

    $logger->debug("Learned new words: $learned_words_count");
    $logger->debug("Lesson duration: $lesson_duration_minutes min.");

    $c->stash(
        subtitles_count     => $tokenizer_stats->{'subtitles_count'},
        total_words_count   => $tokenizer_stats->{'total_words_count'},
        short_words_skipped => $tokenizer_stats->{'short_words_skipped'},
        stop_words_skipped  => $tokenizer_stats->{'stop_words_skipped'},
        words_count_after_filtering =>
            $tokenizer_stats->{'words_count_after_filtering'},
        words_count_after_stemming =>
            $tokenizer_stats->{'words_count_after_stemming'},
        known_words_skipped =>
            $lesson_composer_stats->{'known_words_skipped'},
        actual_lesson_size => n_slov( $lesson->{'words_count'} ),
        lesson_coverage_percentage =>
            $lesson_composer_stats->{'lesson_coverage_percentage'} . ' %',
        learned_words_count => n_slov($learned_words_count),
        lesson_duration     => $lesson_duration,
    );

    return;
}

sub add_to_known_words : Local : Args(1) {
    my ( $self, $c, $word_number ) = @_;

    my $logger = get_logger();
    my $lesson = $c->session->{'lesson'};

    if ( !$lesson ) {
        $logger->warn('Attempt to add known word without lesson');
        redirect_to(
            context   => $c,
            error_msg => 'Невозможно добавить слово '
                . 'так как соответствующий урок не найден '
                . 'или уже закончился'
        );

        return;
    }

    my $words_count = $lesson->{'words_count'};
    return if not $self->_check_word_number( $c, $word_number, $words_count );

    my $word = $lesson->{'words'}[ $word_number - 1 ];

    if ( $lesson->{'is_added_to_known_words'}{$word} ) {
        $logger->warn("Attempt to add duplicate '$word' to known words");
        $c->response->body('duplicate');

        return;
    }

    $logger->debug("Adding '$word' to known words");

    my $lang_id = $c->session->{'cur_lang'}{'id'};
    eval { $c->user()->add_known_word( $lang_id, $word ) };

    if ($EVAL_ERROR) {
        $logger->error("Cannot add '$word' to known words: $EVAL_ERROR");
        $c->response->body('error');

        return;
    }

    $lesson->{'is_added_to_known_words'}{$word} = 1;
    $c->response->body('ok');

    return;
}

__PACKAGE__->meta->make_immutable;

1;
