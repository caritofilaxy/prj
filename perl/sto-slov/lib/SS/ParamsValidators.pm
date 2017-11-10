package SS::ParamsValidators;

#===============================================================================
#     REVISION:  $Id: ParamsValidators.pm 101 2011-11-01 15:55:54Z xdr.box@gmail.com $
#  DESCRIPTION:  Commonly used params validators
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use base qw(Exporter);

use Readonly;
Readonly our $VERSION => qw($Revision: 101 $) [1];

use English qw( -no_match_vars );
use Params::Validate qw(:all);

#use Smart::Comments;

our @EXPORT_OK = qw(
    $VALIDATOR_UNSIGNED_INTEGER
    $VALIDATOR_NOT_EMPTY
    $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR
    $VALIDATOR_LANG
    $VALIDATOR_ARRAYREF_DEFAULT_EMPTY
    $VALIDATOR_ARRAYREF
    $VALIDATOR_CONTEXT
);

Readonly our $VALIDATOR_UNSIGNED_INTEGER => {
    type  => SCALAR(),
    regex => qr/\A\d+\z/xms,
};

Readonly our $VALIDATOR_NOT_EMPTY => {
    type  => SCALAR(),
    regex => qr/\A.+\z/xms,
};

Readonly our $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR => {
    file_name     => $VALIDATOR_NOT_EMPTY,
    max_size      => $VALIDATOR_UNSIGNED_INTEGER,
    max_subtitles => $VALIDATOR_UNSIGNED_INTEGER,
};

## no critic (ProhibitFixedStringMatches)
Readonly our $VALIDATOR_LANG => {
    type  => SCALAR(),
    regex => qr/\Aen\z/xms,
};
## use critic

Readonly our $VALIDATOR_ARRAYREF => { type => ARRAYREF() };

Readonly our $VALIDATOR_ARRAYREF_DEFAULT_EMPTY => {
    type    => ARRAYREF(),
    default => [],
};

Readonly my $VALIDATOR_CONTEXT => { isa => 'SS' };

1;
