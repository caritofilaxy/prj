package SS;

#===============================================================================
#     REVISION:  $Id: SS.pm 161 2012-01-08 09:17:28Z xdr.box@gmail.com $
#  DESCRIPTION:  Top-level web-application module
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use Moose;
use namespace::autoclean;
use utf8;

use Catalyst::Runtime 5.80;

use Catalyst qw(
    ConfigLoader
    Static::Simple
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
    Unicode::Encoding
    StatusMessage
);

extends 'Catalyst';

## no critic (RequireConstantVersion, ProhibitStringyEval)
our $VERSION = '0.01';
$VERSION = eval $VERSION;
## use critic

# Configure the application
__PACKAGE__->config(
    name         => 'SS',
    encoding     => 'UTF-8',
    default_view => 'HTML',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,

    'Plugin::Authentication' => {
        default => {
            class         => 'SimpleDB',
            user_model    => 'DB::User',
            password_type => 'clear',
        },
    },
    'Controller::HTML::FormFu' => {
        constructor => {
            tt_args => { ENCODING => 'UTF-8', },
            form_error_message_xml =>
                '<span class="error">Немного терпения!</span>',
        },
    },

    'View::HTML' => {
        INCLUDE_PATH => [ __PACKAGE__->path_to( 'root', 'src' ) ],
        TIMER        => 0,
        WRAPPER      => 'wrapper.tt2',
        ENCODING     => 'UTF-8',
        EVAL_PERL    => 1,
    },
    'View::JSON' => { expose_stash => qr/\Ajson_/xms, },
);

# Start the application
__PACKAGE__->setup();

1;
