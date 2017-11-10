package SS::Test::User;

#===============================================================================
#     REVISION:  $Id: User.pm 215 2013-03-01 06:48:18Z xdr.box@gmail.com $
#  DESCRIPTION:  Mechanized test user. Core part of t/live-www-common-case.t
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 215 $) [1];

use English qw( -no_match_vars );
use Params::Validate;
use List::MoreUtils qw( mesh );

use Test::WWW::Mechanize::Catalyst;
use Test::Differences;
use Test::More;

use SS::ParamsValidators qw(
    $VALIDATOR_UNSIGNED_INTEGER
);
use SS::Test qw(
    u8
    un8
    get_subtitle_path
);

#use Smart::Comments;

use overload q{""} => sub { $_[0]->username() };

Readonly my $LANG => 'en';
Readonly my $SUBTITLE_FILE =>
    get_subtitle_path('The_Big_Lebowsky_full_en.srt');
Readonly my $LESSON_LIMIT => 10;

Readonly my $DEFAULT_LESSON_LIMIT => 100;
Readonly my @DICT_LIST            => (
    'ABBYY Lingvo.Pro [Грамматический]',
    'Longman English Dictionary [Толковый]'
);
Readonly my $FAVORITE_DICT =>
    'ABBYY Lingvo.Pro [Грамматический]';

Readonly my $LESSON_DEFAULTS_FIRST_TIME => {
    lesson_limit   => '100',
    favorite_dict  => 'Rambler [Грамматический]',
    selected_dicts => [
        {   name     => 'Rambler [Грамматический]',
            selected => 1
        },
        {   name     => 'ABBYY Lingvo.Pro [Грамматический]',
            selected => 1
        },
        {   name     => 'Multitran.RU [Грамматический]',
            selected => 0,
        },
        {   name     => 'Longman English Dictionary [Толковый]',
            selected => 1
        },
        {   name => 'Merriam-Webster English Dictionary [Толковый]',
            selected => 1
        },
        {   name     => 'The Free Dictionary by Farlex [Толковый]',
            selected => 0,
        },
        {   name =>
                'VipDictionary - English dictionary with pictures [Толковый]',
            selected => 0,
        },
    ],
};

Readonly my $LESSON_DEFAULTS_SECOND_TIME => {
    lesson_limit   => $LESSON_LIMIT,
    favorite_dict  => $FAVORITE_DICT,
    selected_dicts => [
        {   name     => 'Rambler [Грамматический]',
            selected => 0,
        },
        {   name     => 'ABBYY Lingvo.Pro [Грамматический]',
            selected => 1,
        },
        {   name     => 'Multitran.RU [Грамматический]',
            selected => 0,
        },
        {   name     => 'Longman English Dictionary [Толковый]',
            selected => 1,
        },
        {   name => 'Merriam-Webster English Dictionary [Толковый]',
            selected => 0,
        },
        {   name     => 'The Free Dictionary by Farlex [Толковый]',
            selected => 0,
        },
        {   name =>
                'VipDictionary - English dictionary with pictures [Толковый]',
            selected => 0,
        },
    ],
};

# NOTE: 3 spaces between word-freq pairs
# NOTE: Unicode NBSP between word and frequency!
Readonly my $TRANSLATE_WORDS_FIRST_TIME =>
    'fucking (218)   man (180)   dude (139)   '
    . 'know (106)   lebowski (86)   walter (63)   '
    . 'don (61)   just (60)   yeah (57)   money (55)';
Readonly my $TRANSLATE_PAGE_TITLE_FISRT_TIME => 'fucking (218) 1/10';

Readonly my @ADD_TO_KNOWN_WORDS => qw(
    fucking
    man
    dude
);

Readonly my $TRANSLATE_WORDS_SECOND_TIME =>
    'know (106)   lebowski (86)   walter (63)   '
    . 'don (61)   just (60)   yeah (57)   money (55)   '
    . 'well (53)   get (49)   got (43)';

sub new {
    my $class = shift;
    my %p = validate( @_, { number => $VALIDATOR_UNSIGNED_INTEGER } );

    my $mech = Test::WWW::Mechanize::Catalyst->new( catalyst_app => 'SS' );
    my $self = { %p, mech => $mech };

    return bless $self, $class;
}

sub number {
    my $self = shift;

    return $self->{'number'};
}

sub mech {
    my $self = shift;

    return $self->{'mech'};
}

sub username {
    my $self = shift;

    return 'user' . $self->number();
}

sub password {
    my $self = shift;

    return 'password' . $self->number();
}

sub new_password {
    my $self = shift;

    return 'password-new' . $self->number();
}

sub email {
    my $self = shift;

    return join q{@}, $self->username(), q{foobar.com};
}

sub new_email {
    my $self = shift;

    return join q{@}, $self->username(), q{foobar-new.com};
}

sub go_to_welcome_page {
    my $self = shift;

    $self->mech->get_ok( q{/}, "$self: go to welcome page" );
    $self->mech->content_contains( 'WELCOME_PAGE_MARKER',
        "$self: page contains WELCOME_PAGE_MARKER" );

    return;
}

sub start_lesson_anonymous {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/lesson/start/$LANG\z}xms },
        "$self: go to start '$LANG' lesson page as anonymous"
    );
    $self->mech->content_contains( 'START_LESSON_PAGE_MARKER',
        "$self: page contains START_LESSON_PAGE_MARKER" );

    my $lesson_defaults = $self->_get_start_lesson_defaults();

    eq_or_diff( $lesson_defaults, $LESSON_DEFAULTS_FIRST_TIME,
        "$self: check lesson defaults" );

    $self->mech->form_id('lesson_start_form');

    $self->_select_dicts(@DICT_LIST);
    $self->mech->select( 'default_dictionary_id', u8($FAVORITE_DICT) );

    $self->mech->submit_form_ok(
        {   form_id => 'lesson_start_form',
            fields  => {
                subtitle_file => $SUBTITLE_FILE,
                lesson_limit  => $LESSON_LIMIT,
            },
            button => 'submit',
        },
        "$self: start lesson"
    );
    $self->mech->content_contains( 'TRANSLATE_WORD_PAGE_MARKER',
        "$self: redirected to translate word page" );

    # $self->mech->dump_text();
    $self->mech->text_contains( u8($TRANSLATE_WORDS_FIRST_TIME),
        "$self: page contains correct words to translate" );

    my $title = $TRANSLATE_PAGE_TITLE_FISRT_TIME;    # no username here
    $self->mech->title_is( u8($title), "$self: page title is '$title'" );

    return;
}

sub translate_few_words_anonymous {
    my $self = shift;

    # get current (first) word from the title
    my $title1 = $self->mech->title();

    $self->mech->follow_link_ok( { text => u8('→') },
        "$self: proceed to the next word" );

    $self->mech->follow_link_ok( { text => u8('←') },
        "$self: return to the previous word" );

    my $title2 = $self->mech->title();

    ok( $title2 eq $title1,
        "$self: check '→' and '←' links work as expected" );

    return;
}

sub finish_lesson_anonymous {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/lesson/finish\z}xms },
        "$self: finish lesson as anonymous"
    );

    $self->mech->content_contains( 'FINISH_LESSON_PAGE_MARKER',
        "$self: page contains FINISH_LESSON_PAGE_MARKER" );

    my $stat_item
        = 'С учётом уже известных слов и установленного '
        . "ограничения вам показано:$LESSON_LIMIT слов";
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    $stat_item = 'В этом уроке вы выучили:0 слов';
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    return;
}

sub register_account {
    my $self = shift;

    $self->mech->follow_link_ok( { url_regex => qr{/user/register\z}xms },
        "$self: go to register page" );
    $self->mech->content_contains( 'REGISTER_PAGE_MARKER',
        "$self: page contains REGISTER_PAGE_MARKER" );

    $self->mech->submit_form_ok(
        {   form_id => 'register_form',
            fields  => {
                username        => $self->username(),
                password        => $self->password(),
                repeat_password => $self->password(),
                email           => $self->email(),
            },
            button => 'submit',
        },
        "$self: register account"
    );
    $self->mech->content_contains( 'LOGIN_PAGE_MARKER',
        "$self: redirected to login page" );

    my $message
        = 'Отлично '
        . $self->username()
        . ', теперь входите!';
    $self->mech->content_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

sub login {
    my $self = shift;

    $self->mech->follow_link_ok( { url_regex => qr{/user/login\z}xms },
        "$self: go to login page" );
    $self->mech->content_contains( 'LOGIN_PAGE_MARKER',
        "$self: page contains LOGIN_PAGE_MARKER" );

    $self->mech->submit_form_ok(
        {   form_id => 'login_form',
            fields  => {
                username => $self->username(),
                password => $self->password(),
            },
            button => 'submit',
        },
        "$self: login"
    );
    $self->mech->content_contains( 'WELCOME_PAGE_MARKER',
        "$self: redirected to welcome page" );

    my $message
        = q{Добро пожаловать, } . $self->username() . q{!};
    $self->mech->content_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

sub start_lesson_auth_first_time {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/lesson/start/$LANG\z}xms },
        "$self: go to start '$LANG' lesson page as auth user, 1st time" );
    $self->mech->content_contains( 'START_LESSON_PAGE_MARKER',
        "$self: page contains START_LESSON_PAGE_MARKER" );

    my $lesson_defaults = $self->_get_start_lesson_defaults();

    eq_or_diff( $lesson_defaults, $LESSON_DEFAULTS_FIRST_TIME,
        "$self: check lesson defaults" );

    $self->mech->form_id('lesson_start_form');

    $self->_select_dicts(@DICT_LIST);
    $self->mech->select( 'default_dictionary_id', u8($FAVORITE_DICT) );

    $self->mech->submit_form_ok(
        {   form_id => 'lesson_start_form',
            fields  => {
                subtitle_file       => $SUBTITLE_FILE,
                lesson_limit        => $LESSON_LIMIT,
                save_my_preferences => 1,
            },
            button => 'submit',
        },
        "$self: start lesson"
    );
    $self->mech->content_contains( 'TRANSLATE_WORD_PAGE_MARKER',
        "$self: redirected to translate word page" );

    # $self->mech->dump_text();
    $self->mech->text_contains( u8($TRANSLATE_WORDS_FIRST_TIME),
        "$self: page contains correct words to translate" );

    my $title = "$TRANSLATE_PAGE_TITLE_FISRT_TIME - $self";
    $self->mech->title_is( u8($title), "$self: page title is '$title'" );

    return;
}

sub translate_few_words_auth_first_time {
    my $self = shift;

    # add current (first in lesson) word to known words
    my $word = $ADD_TO_KNOWN_WORDS[0];
    $self->mech->form_name('add_to_known_words_form');
    $self->mech->click_ok( 'add_to_known_words',
        "$self: add '$word' to known words" );
    $self->mech->content_is( 'ok', "$self: check '$word' has been added" );
    $self->mech->back();

    # translate next word, add it to known words too
    $word = $ADD_TO_KNOWN_WORDS[1];
    $self->mech->follow_link_ok( { text => u8('→') },
        "$self: proceed to next word - '$word'" );
    $self->mech->title_like( qr/\A$word\s/xms,
        "$self: page title starts with '$word'" );
    $self->mech->click_ok( 'add_to_known_words',
        "$self: add '$word' to known words" );
    $self->mech->content_is( 'ok', "$self: check '$word' has been added" );
    $self->mech->back();

    # translate another word, hit direct link, add it to known words too
    $word = $ADD_TO_KNOWN_WORDS[2];
    $self->mech->follow_link_ok(
        {   text_regex => qr/$word/xms,
            url_regex  => qr{/translate_word/\d+\z}xms,
        },
        "$self: jump to word '$word' using direct link"
    );
    $self->mech->title_like( qr/\A$word\s/xms,
        "$self: page title starts with '$word'" );
    $self->mech->click_ok( 'add_to_known_words',
        "$self: add '$word' to known words" );
    $self->mech->content_is( 'ok', "$self: check '$word' has been added" );
    $self->mech->back();

    $self->mech->click_ok( 'add_to_known_words',
        "$self: try to add '$word' to known words again" );
    $self->mech->content_is( 'duplicate',
        "$self: check that duplicate '$word' was detected" );
    $self->mech->back();

    return;
}

sub finish_lesson_auth_first_time {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/lesson/finish\z}xms },
        "$self: finish lesson as auth user, 1st time"
    );

    #$self->mech->dump_text();

    my $stat_item
        = 'С учётом уже известных слов и установленного '
        . "ограничения вам показано:$LESSON_LIMIT слов";
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    $stat_item
        = 'В этом уроке вы выучили:'
        . ( scalar @ADD_TO_KNOWN_WORDS )
        . ' слов';
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    return;
}

sub start_lesson_auth_second_time {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/lesson/start/$LANG\z}xms },
        "$self: go to start '$LANG' lesson page as auth user, 2nd time" );
    $self->mech->content_contains( 'START_LESSON_PAGE_MARKER',
        "$self: page contains START_LESSON_PAGE_MARKER" );

    my $lesson_defaults = $self->_get_start_lesson_defaults();

    eq_or_diff( $lesson_defaults, $LESSON_DEFAULTS_SECOND_TIME,
        "$self: lesson defaults are taken from user preferences" );

    $self->mech->submit_form_ok(
        {   form_id => 'lesson_start_form',
            fields  => { subtitle_file => $SUBTITLE_FILE, },
            button  => 'submit',
        },
        "$self: start lesson (with all default values, except file)"
    );
    $self->mech->content_contains( 'TRANSLATE_WORD_PAGE_MARKER',
        "$self: redirected to translate word page" );

    #$self->mech->dump_text();
    $self->mech->text_contains( u8($TRANSLATE_WORDS_SECOND_TIME),
        "$self: page doesn't contain words that user marked as known before"
    );

    return;
}

sub translate_few_words_auth_second_time {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/translate_word/$LESSON_LIMIT\z}xms, },
        "$self: jump to last word ($LESSON_LIMIT) in lesson using direct link"
    );
    $self->mech->follow_link_ok( { text => u8('→') },
        "$self: hit 'next word' link: '→'" );

    $self->mech->content_contains( 'FINISH_LESSON_PAGE_MARKER',
        "$self: redirected to finish lesson page" );

    return;
}

sub finish_lesson_auth_second_time {
    my $self = shift;

    my $stat_item = 'Отброшено известных вам слов:'
        . ( scalar @ADD_TO_KNOWN_WORDS );
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    $stat_item
        = 'С учётом уже известных слов и установленного '
        . "ограничения вам показано:$LESSON_LIMIT слов";
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    $stat_item = 'В этом уроке вы выучили:0 слов';
    $self->mech->text_contains( u8($stat_item),
        "$self: stat contains '$stat_item'" );

    return;
}

sub manage_known_words {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/known_words/show_all/$LANG\z}xms },
        "$self: manage known words ($LANG)" );
    $self->mech->content_contains( 'SHOW_KNOWN_WORDS_PAGE_MARKER',
        "$self: redirected to 'known words' page" );

    #$self->mech->dump_text();

    my $known_words_count = scalar @ADD_TO_KNOWN_WORDS;
    my $summary
        = "Список известных слов ($known_words_count)";
    $self->mech->text_contains( u8($summary),
        "$self: page contains '$summary'" );

    my @checkboxes = $self->mech->find_all_inputs( type => 'checkbox' );

    # mark all known words for deletion
    foreach my $checkbox (@checkboxes) {
        $checkbox->check();
    }

    $self->mech->submit_form_ok(
        {   form_id => 'known_words_show_all_form',
            button  => 'submit',
        },
        "$self: delete all known words ($known_words_count)"
    );

    my $message = "Удалено $known_words_count слов";
    $self->mech->text_contains( u8($message),
        "$self: page contains '$message'" );

    $summary = 'Список известных слов (0)';
    $self->mech->text_contains( u8($summary),
        "$self: page contains '$summary'" );

    return;
}

sub change_email {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/\z}xms },
        "$self: go to 'my account' page"
    );
    $self->mech->content_contains( 'MY_ACCOUNT_PAGE_MARKER',
        "$self: page contains MY_ACCOUNT_PAGE_MARKER" );

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/change_email\z}xms },
        "$self: go to 'change email' page"
    );
    $self->mech->content_contains( 'CHANGE_EMAIL_PAGE_MARKER',
        "$self: page contains CHANGE_EMAIL_PAGE_MARKER" );

    my $new_email = $self->new_email();
    $self->mech->submit_form_ok(
        {   form_id => 'change_email_form',
            fields  => { email => $new_email },
            button  => 'submit',
        },
        "$self: change email to '$new_email'"
    );

    my $message = 'Email успешно изменён';
    $self->mech->text_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

sub change_password {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/\z}xms },
        "$self: go to 'my account' page"
    );
    $self->mech->content_contains( 'MY_ACCOUNT_PAGE_MARKER',
        "$self: page contains MY_ACCOUNT_PAGE_MARKER" );

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/change_password\z}xms },
        "$self: go to 'change password' page"
    );
    $self->mech->content_contains( 'CHANGE_PASSWORD_PAGE_MARKER',
        "$self: page contains CHANGE_PASSWORD_PAGE_MARKER" );

    my $new_password = $self->new_password();
    $self->mech->submit_form_ok(
        {   form_id => 'change_password_form',
            fields  => {
                password        => $new_password,
                repeat_password => $new_password,
            },
            button => 'submit',
        },
        "$self: change password to '$new_password'"
    );

    my $message = 'Пароль успешно изменён';
    $self->mech->text_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

sub logout {
    my $self = shift;

    $self->mech->follow_link_ok( { url_regex => qr{/user/logout\z}xms },
        "$self: logout" );
    $self->mech->content_contains( 'WELCOME_PAGE_MARKER',
        "$self: page contains WELCOME_PAGE_MARKER" );

    my $message = q{Ждём вас снова, } . $self->username() . q{!};
    $self->mech->text_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

sub remove_account {
    my $self = shift;

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/\z}xms },
        "$self: go to 'my account' page"
    );
    $self->mech->content_contains( 'MY_ACCOUNT_PAGE_MARKER',
        "$self: page contains MY_ACCOUNT_PAGE_MARKER" );

    $self->mech->follow_link_ok(
        { url_regex => qr{/user/remove\z}xms },
        "$self: go to 'remove account' page"
    );
    $self->mech->content_contains( 'REMOVE_ACCOUNT_PAGE_MARKER',
        "$self: page contains REMOVE_ACCOUNT_PAGE_MARKER" );

    $self->mech->submit_form_ok(
        {   form_id => 'remove_account_form',
            fields  => {},
            button  => 'submit',
        },
        "$self: remove account (completely)"
    );

    my $message = 'Ваш аккаунт удалён. Совсем.';
    $self->mech->text_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

#-------------------------------------------------------------------------------
#  Private methods
#-------------------------------------------------------------------------------

sub _get_start_lesson_defaults {
    my $self = shift;

    $self->mech->form_id('lesson_start_form');
    my $lesson_limit = $self->mech->value('lesson_limit');

    my $name_of = $self->_get_dict_id_to_name_map();
    my $favorite_dict
        = un8( $name_of->{ $self->mech->value('default_dictionary_id') } );

    my @checkboxes
        = $self->mech->find_all_inputs( name => 'dictionary_id_list' );

    # TRICKY: See HTML::Form(::ListInput) source
    my @selected_dicts = ();
    foreach my $checkbox (@checkboxes) {
        my $dict_id = ( $checkbox->possible_values() )[1];
        push @selected_dicts,
            {
            name     => un8( $name_of->{$dict_id} ),
            selected => defined $checkbox->value() ? 1 : 0,
            };
    }

    my $defaults = {
        lesson_limit   => $lesson_limit,
        favorite_dict  => $favorite_dict,
        selected_dicts => \@selected_dicts,
    };
    ### start lesson defaults: $defaults

    return $defaults;
}

sub _get_all_dict_ids {
    my $self = shift;

    my @inputs
        = $self->mech->find_all_inputs( name => 'default_dictionary_id' );
    my $select = $inputs[0];

    my @dict_ids = $select->possible_values();

    return \@dict_ids;
}

sub _get_dict_name_to_id_map {
    my $self = shift;

    my @inputs
        = $self->mech->find_all_inputs( name => 'default_dictionary_id' );
    my $select = $inputs[0];

    my @dict_ids   = $select->possible_values();
    my @dict_names = $select->value_names();

    my %dict_name_to_id = mesh @dict_names, @dict_ids;

    return \%dict_name_to_id;
}

sub _get_dict_id_to_name_map {
    my $self = shift;

    my %dict_name_to_id = %{ $self->_get_dict_name_to_id_map() };
    my @names           = keys %dict_name_to_id;
    my @ids             = values %dict_name_to_id;
    my %dict_id_to_name = mesh @ids, @names;

    return \%dict_id_to_name;
}

sub _untick_all_dicts {
    my $self = shift;

    my $dict_ids = $self->_get_all_dict_ids();
    ### dict_ids: $dict_ids

    foreach my $dict_id ( @{$dict_ids} ) {
        $self->mech->untick( 'dictionary_id_list', $dict_id );
    }

    return;
}

sub _select_dicts {
    my $self       = shift;
    my @dict_names = @_;

    $self->mech->form_id('lesson_start_form');

    $self->_untick_all_dicts();

    my $id_of = $self->_get_dict_name_to_id_map();
    ### id_of: $id_of

    foreach my $dict_name (@dict_names) {
        ### ticking dict: $dict_name
        $self->mech->tick( 'dictionary_id_list', $id_of->{ u8($dict_name) } );
    }

    return;
}

sub login_with_new_password {
    my $self = shift;

    $self->mech->follow_link_ok( { url_regex => qr{/user/login\z}xms },
        "$self: go to login page" );
    $self->mech->content_contains( 'LOGIN_PAGE_MARKER',
        "$self: page contains LOGIN_PAGE_MARKER" );

    $self->mech->submit_form_ok(
        {   form_id => 'login_form',
            fields  => {
                username => $self->username(),
                password => $self->new_password(),
            },
            button => 'submit',
        },
        "$self: login with new password"
    );
    $self->mech->content_contains( 'WELCOME_PAGE_MARKER',
        "$self: redirected to welcome page" );

    my $message
        = q{Добро пожаловать, } . $self->username() . q{!};
    $self->mech->content_contains( u8($message),
        "$self: page contains '$message'" );

    return;
}

1;
