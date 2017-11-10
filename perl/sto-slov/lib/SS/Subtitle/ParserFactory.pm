package SS::Subtitle::ParserFactory;

#===============================================================================
#     REVISION:  $Id: ParserFactory.pm 12 2011-09-09 15:32:13Z xdr.box@gmail.com $
#  DESCRIPTION:  Factory that creates proper subtitle parser object
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 12 $) [1];

use English qw( -no_match_vars );
use Params::Validate;
use File::Basename;
use Carp;

#use Smart::Comments;

use SS::Log;
use SS::LogParams;
use SS::ParamsValidators qw(
    $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR
);

use SS::Subtitle::Parser::SRT;

Readonly my $PARSER_FOR => { '.srt' => 'SS::Subtitle::Parser::SRT' };

#-------------------------------------------------------------------------------
#  Public API
#-------------------------------------------------------------------------------

sub create : Log( result => 0 ) {
    my $class = shift;
    my %params = validate( @_, $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR );

    my ( undef, undef, $ext )
        = fileparse( lc $params{'file_name'}, qr/[.][^.]*/xms );

    if ( !$ext ) {
        confess "Cannot find extension of '$params{'file_name'}'";
    }

    if ( !$PARSER_FOR->{$ext} ) {
        confess "Cannot find parser for '$ext' subtitle format";
    }

    my $logger = get_logger();
    $logger->debug("Creating '$PARSER_FOR->{$ext}' parser");

    my $parser = $PARSER_FOR->{$ext}->new(%params);

    return $parser;
}

1;
