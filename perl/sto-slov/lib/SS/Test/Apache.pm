package SS::Test::Apache;

#===============================================================================
#     REVISION:  $Id: Apache.pm 200 2012-01-13 19:34:40Z xdr.box@gmail.com $
#  DESCRIPTION:  On-demand temporary Apache2/mod_perl instance with
#                automatic configuration and cleanup
#        TESTS:  t/ss_test_apache.t
#     ENV VARS:  - DONT_CLEANUP
#                - TEST_VERBOSE
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 200 $) [1];

use English qw( -no_match_vars );
use File::Slurp qw( slurp write_file );
use Params::Validate qw( :all );
use Template;
use Carp;
use Fatal qw( close mkdir );

#use Smart::Comments;

use SS::Log;
use SS::Test qw(
    create_tmp_dir
);

Readonly my $DEFAULT_PERL_RESPONSE_HANDLER => 'SS';
Readonly my $DEFAULT_LOG_LEVEL             => 'warn';
Readonly my @DEFAULT_LIBS                  => ("$ENV{'SS_ROOT'}/lib");
Readonly my $DEFAULT_PERL_SWITCHES         => q{};
Readonly my $DEFAULT_PERL_OPTIONS          => '-ParseHeaders';

Readonly my $AUTH_RELAM          => 'Test SS server';
Readonly my $APACHE_MODULES_PATH => '/usr/lib/apache2/modules/';
Readonly my @APACHE_MODULES      => qw(
    perl
    authz_user
    authz_default
);

Readonly my $APACHE2 => '/usr/sbin/apache2';

Readonly my $SIG_KILL => 9;
Readonly my $SIG_TERM => 15;

# Give Apache some time to start App and create PID file
Readonly my $APACHE_START_DELAY => 10;

# Give Apache some time to exit and save NYTProf data
# so that 'nytprofhtml' tool could generate report
Readonly my $APACHE_STOP_DELAY => 3;

my $CONFIG_TEMPLATE = <<'END_CONFIG_TEMPLATE';
Listen     [% port %]
ServerRoot [% server_root %]

LockFile apache.lock
PidFile  apache.pid

User  [% user %]
Group [% group %]

HostnameLookups Off

LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined

LogLevel [% log_level %]
ErrorLog error.log

PerlPassEnv SS_ROOT
PerlPassEnv SS_CONFIG
PerlPassEnv LOG4PERL_CONFIG
PerlPassEnv CATALYST_DEBUG

[% IF enable_profiling %]
    PerlPassEnv NYTPROF
    PerlModule Devel::NYTProf::Apache
[% END %]

[% IF single_process OR enable_profiling %]
    StartServers         1
    MinSpareServers      1
    MaxSpareServers      1
    MaxClients           1
    MaxRequestsPerChild  0
[% END %]

[% FOREACH module IN modules %]
    LoadModule [% module _ '_module' %] [% modules_path _ 'mod_' _ module _ '.so' %]
[% END %]

PerlSwitches [% add_to_INC %] [% perl_switches %]
PerlOptions [% perl_options %]

PerlModule SS

<VirtualHost *:[% port %]>
    ServerAdmin [% server_admin %]
    ServerName  [% server_name %]

    DocumentRoot [% document_root %]

    LogLevel  [% log_level %]
    ErrorLog  error.log
    CustomLog access.log combined

    [% IF extra_perl_code %]
    <Perl>
        [% extra_perl_code %]
    </Perl>
    [% END %]

    <Location />
        SetHandler modperl

        [% IF perl_authen_handler %]
        PerlAuthenHandler   [% perl_authen_handler %]
        [% END %]
        [% IF perl_authz_handler %]
        PerlAuthzHandler    [% perl_authz_handler %]
        [% END %]
        [% IF perl_response_handler %]
        PerlResponseHandler [% perl_response_handler %]
        [% END %]

        [% IF perl_authen_handler %]
        AuthType Basic
        AuthName "[% auth_relam %]"
        Require  valid-user
        [% END %]
    </Location>
</VirtualHost>
END_CONFIG_TEMPLATE

#-------------------------------------------------------------------------------
#  Public API
#-------------------------------------------------------------------------------

sub run {
    my $class = shift;

    my %p = validate(
        @_,
        {   port      => { default => _generate_random_port() },
            log_level => { default => $DEFAULT_LOG_LEVEL },
            user      => { default => _get_current_user_name() },
            group     => { default => _get_current_group_name() },
            libs      => { type    => ARRAYREF(), default => \@DEFAULT_LIBS },
            perl_switches       => { default => $DEFAULT_PERL_SWITCHES },
            perl_options        => { default => $DEFAULT_PERL_OPTIONS },
            perl_authen_handler => 0,
            perl_authz_handler  => 0,
            perl_response_handler =>
                { default => $DEFAULT_PERL_RESPONSE_HANDLER },
            single_process   => 0,
            extra_perl_code  => 0,
            enable_profiling => { default => $ENV{'NYTPROF'} ? 1 : 0 },
        }
    );

    my $logger = get_logger();
    my $self   = {%p};

    if (   !$p{'perl_authen_handler'}
        && !$p{'perl_authz_handler'}
        && !$p{'perl_response_handler'} )
    {
        confess 'You should provide at least one handler';
    }

    my $server_root = create_tmp_dir('apache');
    $self->{'server_root'} = $server_root;

    my $document_root = "$server_root/htdocs";
    mkdir $document_root;

    my $logs_dir = "$server_root/logs";
    mkdir $logs_dir;

    ## no critic (Capitalization)
    my $add_to_INC = join q{ }, map {"-I$_"} @{ $p{'libs'} };
    ## use critic

    my $config = _generate_config(
        %p,
        server_root   => $server_root,
        document_root => $document_root,
        server_name   => 'localhost',
        server_admin  => 'postmaster@localhost',
        add_to_INC    => $add_to_INC,
        auth_relam    => $AUTH_RELAM,
        modules       => \@APACHE_MODULES,
        modules_path  => $APACHE_MODULES_PATH,
    );
    my $config_name = "$server_root/apache.conf";
    write_file( $config_name, $config );

    my $pid = _start_apache_instance( $config_name, $server_root );
    $self->{'pid'} = $pid;

    $logger->info(
        sprintf 'Starting Apache: port=%s, server_root=%s, pid=%s',
        $self->{'port'}, $self->{'server_root'},
        $self->{'pid'}
    );

    return bless $self, $class;
}

sub get_port {
    my $self = shift;

    return $self->{'port'};
}

sub get_server_root {
    my $self = shift;

    return $self->{'server_root'};
}

sub get_pid {
    my $self = shift;

    return $self->{'pid'};
}

#-------------------------------------------------------------------------------
#  Private methods
#-------------------------------------------------------------------------------

sub _slurp_error_log {
    my $server_root = shift;

    my $error_log_path = "$server_root/error.log";
    my $error_log_data
        = -e $error_log_path ? slurp $error_log_path : q{Nothing};
    my $report = <<"END_REPORT";

$error_log_path:
====================================
$error_log_data
====================================
END_REPORT

    return $report;
}

#-------------------------------------------------------------------------------
#  Private functions
#-------------------------------------------------------------------------------

sub _get_current_user_name {
    return ( getpwuid $EUID )[0];
}

sub _get_current_group_name {
    return ( getgrgid $EGID )[0];
}

sub _generate_random_port {
    ## no critic (ProhibitMagicNumbers)
    return 10_000 + int rand 30_000;
}

sub _generate_config {
    my %p = @_;

    my $tt = Template->new();

    my $config = q{};
    if ( !$tt->process( \$CONFIG_TEMPLATE, \%p, \$config ) ) {
        confess 'Cannot generate config: ' . $tt->error();
    }
    ### config: $config

    return $config;
}

sub _start_apache_instance {
    my $config_name = shift;
    my $server_root = shift;

    local $ENV{'LC_ALL'} = 'C';    # Error messages in English

    my $output = `$APACHE2 -f $config_name 2>&1`;

    if ( $CHILD_ERROR != 0 ) {
        confess "Cannot start apache: $output"
            . _slurp_error_log($server_root);
    }

    sleep $APACHE_START_DELAY;

    my $pid = `cat $server_root/apache.pid`;
    chomp $pid;

    if ( $pid !~ /\A\d+\z/xms ) {
        confess 'Cannot get PID of apache process'
            . _slurp_error_log($server_root);
    }

    return $pid;
}

sub DESTROY {
    my $self = shift;

    my $logger = get_logger();

    if ( $ENV{'DONT_CLEANUP'} ) {
        $logger->warn(
            'DONT_CLEANUP environment variable is set. Skipping automatic cleanup'
        );

        return;
    }

    $logger->info(
        sprintf 'Stopping Apache: port=%s, server_root=%s, pid=%s',
        $self->get_port(), $self->get_server_root(),
        $self->get_pid()
    );

    kill $SIG_TERM, $self->get_pid();
    sleep $APACHE_STOP_DELAY;

    if ( $ENV{'TEST_VERBOSE'} ) {
        $logger->debug( _slurp_error_log( $self->get_server_root() ) );
    }

    return;
}

1;
