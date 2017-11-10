package SS::View::HTML;

#===============================================================================
#     REVISION:  $Id: HTML.pm 43 2011-10-12 16:09:05Z xdr.box@gmail.com $
#  DESCRIPTION:  Default HTML View
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 43 $) [1];

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die         => 1,
);

1;
