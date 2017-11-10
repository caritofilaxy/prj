package SS::Model::DB;

#===============================================================================
#     REVISION:  $Id: DB.pm 48 2011-10-14 14:16:52Z xdr.box@gmail.com $
#  DESCRIPTION:  Model configuration (SQLite)
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use base qw(Catalyst::Model::DBIC::Schema);

use Readonly;
Readonly our $VERSION => qw($Revision: 48 $) [1];

__PACKAGE__->config(
    schema_class => 'SS::Schema',

    connect_info => {
        dsn            => 'dbi:SQLite:ss.db',
        user           => q{},
        password       => q{},
        on_connect_do  => q{PRAGMA foreign_keys = ON},
        sqlite_unicode => 1,
    }
);

1;
