package SS::Test;

#===============================================================================
#     REVISION:  $Id: Test.pm 205 2012-02-24 17:06:17Z xdr.box@gmail.com $
#  DESCRIPTION:  Helper test functions
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#     ENV VARS:  - DONT_CLEANUP
#                - CATALYST_DEBUG
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 205 $) [1];

use English qw( -no_match_vars );
use File::Temp qw( tempdir );
use Carp;
use Template;
use Encode;

#use Smart::Comments;

use SS::Utils qw(
    check_SS_ROOT
);
use SS::Log;
use Log::Log4perl;

use base qw(Exporter);

our @EXPORT_OK = qw(
    get_subtitle_path
    create_tmp_dir
    init_test_environment
    u8
    un8
);

INIT {
    check_SS_ROOT();
}

Readonly my $DB_FILE_NAME         => 'ss.db';
Readonly my $APP_CONFIG_NAME      => 'ss.perl';
Readonly my $LOG4PERL_CONFIG_NAME => 'ss.log4perl';
Readonly my $LOG_FILE_NAME        => 'ss.log';
Readonly my $SUBTITLES_DIR_NAME   => 'subtitles';

Readonly my $SQLITE_CMD => 'sqlite3';

sub get_subtitle_path {
    my $subtitle_file = shift;

    return "$ENV{'SS_ROOT'}/t/subtitles/$subtitle_file";
}

sub create_tmp_dir {
    my $dir_prefix = shift || 'ss_test';

    my $tmp_dir = tempdir(
        $dir_prefix . '_XXXX',
        TMPDIR  => 1,
        CLEANUP => ( $ENV{'DONT_CLEANUP'} ? 0 : 1 )
    );
    ### tmp_dir: $tmp_dir

    return $tmp_dir;
}

sub init_test_environment {
    my $tmp_dir = create_tmp_dir();

    _init_db($tmp_dir);
    _init_subtitles_dir($tmp_dir);
    _generate_app_config($tmp_dir);
    _generate_log4perl_config($tmp_dir);

    my $logger = get_logger();
    $logger->info("Testing environment: $tmp_dir");

    return $tmp_dir;
}

sub u8 {
    my $str = shift;

    return decode( 'utf-8', $str );
}

sub un8 {
    my $str = shift;

    return encode( 'utf-8', $str );
}

sub _init_db {
    my $tmp_dir = shift;

    my $sql_file = "$ENV{'SS_ROOT'}/ss.sqlite";
    my $db_file  = "$tmp_dir/$DB_FILE_NAME";

    system "$SQLITE_CMD $db_file < $sql_file";

    if ( $CHILD_ERROR != 0 ) {
        confess "Cannot init DB '$db_file'";
    }

    return;
}

sub _init_subtitles_dir {
    my $tmp_dir = shift;

    system "mkdir '$tmp_dir/$SUBTITLES_DIR_NAME'";

    if ( $CHILD_ERROR != 0 ) {
        confess "Cannot create dir '$tmp_dir/$SUBTITLES_DIR_NAME'";
    }

    return;
}

sub _generate_app_config {
    my $tmp_dir = shift;

    my $template = <<'END_TEMPLATE';
{   name          => 'SS',

    min_password_length => 6,
    max_password_length => 16,

    min_username_length => 3,
    max_username_length => 16,

    min_lesson_limit => 10,
    max_lesson_limit => 1000,

    subtitles => {
        dir           => '[* subtitles_dir *]',
        max_size      => 0,
        max_subtitles => 10_000,
    },
    'Model::DB' => {
        connect_info => {
            dsn            => 'dbi:SQLite:[* db_file *]',
            user           => q{},
            password       => q{},
            on_connect_do  => q{PRAGMA foreign_keys = ON},
            sqlite_unicode => 1,
        }
    },
}
END_TEMPLATE
    my $tt = Template->new( TAG_STYLE => 'star' );

    my $app_config = "$tmp_dir/$APP_CONFIG_NAME";
    my $params     = {
        subtitles_dir => "$tmp_dir/$SUBTITLES_DIR_NAME",
        db_file       => "$tmp_dir/$DB_FILE_NAME",
    };

    if ( !$tt->process( \$template, $params, $app_config ) ) {
        confess "Cannot generate config '$app_config:" . $tt->error();
    }

    ## no critic (RequireLocalizedPunctuationVars)
    $ENV{'SS_CONFIG'} = $app_config;

    return;
}

sub _generate_log4perl_config {
    my $tmp_dir = shift;

    my $template = <<'END_TEMPLATE';
[* IF log_to_screen *]
log4perl.rootlogger = DEBUG, File, Screen
[* ELSE *]
log4perl.rootlogger = DEBUG, File
[* END *]

conversion_pattern = [%d{yyyy-MM-dd HH:mm:ss}] [%p] [%X{username}] [%X{action}] %M(%L): %m%n

log4perl.appender.File = Log::Dispatch::File
log4perl.appender.File.filename = [* log_file *]
log4perl.appender.File.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.File.layout.ConversionPattern = ${conversion_pattern}

[* IF log_to_screen *]
log4perl.appender.Screen = Log::Log4perl::Appender::ScreenColoredLevels
log4perl.appender.Screen.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Screen.layout.ConversionPattern = ${conversion_pattern}
[* END *]
END_TEMPLATE
    my $tt = Template->new( TAG_STYLE => 'star' );

    my $log4perl_config = "$tmp_dir/$LOG4PERL_CONFIG_NAME";
    my $params          = {
        log_file => "$tmp_dir/$LOG_FILE_NAME",
        log_to_screen =>
            ( $ENV{'TEST_VERBOSE'} and not $ENV{'CATALYST_SERVER'} ) ? 1 : 0,
    };

    if ( !$tt->process( \$template, $params, $log4perl_config ) ) {
        confess "Cannot generate config '$log4perl_config:" . $tt->error();
    }

    ## no critic (RequireLocalizedPunctuationVars)
    $ENV{'LOG4PERL_CONFIG'} = $log4perl_config;

    Log::Log4perl::MDC->put( 'username', 'SYSTEM' );
    Log::Log4perl::MDC->put( 'action',   'N/A' );

    return;
}

1;
