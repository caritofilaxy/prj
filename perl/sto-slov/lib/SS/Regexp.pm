package SS::Regexp;

#===============================================================================
#     REVISION:  $Id: Regexp.pm 5 2011-09-06 11:37:41Z xdr.box@gmail.com $
#  DESCRIPTION:  Commonly used regexps
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use base qw(Exporter);

use Readonly;
Readonly our $VERSION => qw($Revision: 5 $) [1];

use English qw( -no_match_vars );

#use Smart::Comments;

our @EXPORT_OK = qw(
    $NOT_EMPTY_RE
    $FLAG_01_RE
);

Readonly our $NOT_EMPTY_RE => qr/\A.+\z/xms;
Readonly our $FLAG_01_RE   => qr/\A[01]\z/xms;

1;
