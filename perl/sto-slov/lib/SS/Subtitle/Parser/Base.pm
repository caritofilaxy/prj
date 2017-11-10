package SS::Subtitle::Parser::Base;

#===============================================================================
#     REVISION:  $Id: Base.pm 19 2011-09-12 12:36:00Z xdr.box@gmail.com $
#  DESCRIPTION:  Base class for subtitle parsers
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

our $VERSION = qw($Revision: 19 $) [1];  ## no critic (RequireConstantVersion)

use Readonly;
use English qw( -no_match_vars );
use Params::Validate;
use Carp;
use HTML::Strip;

#use Smart::Comments;

use SS::Log;
use SS::LogParams;
use SS::ParamsValidators qw(
    $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR
);

#-------------------------------------------------------------------------------
#  Public API
#-------------------------------------------------------------------------------

sub new {
    my $class = shift;
    my %params = validate( @_, $VALIDATOR_SUBTITLE_PARSER_CONSTRUCTOR );

    ## no critic (ProhibitParensWithBuiltins, RequireBriefOpen)
    open( my $fh, q{<}, $params{'file_name'} )
        or confess "Cannot open '$params{'file_name'}': $OS_ERROR";
    ## use critic

    # zero max_size = no size limit
    if ( $params{'max_size'} ) {
        my $file_size = -s $params{'file_name'};
        if ( $file_size > $params{'max_size'} ) {
            confess "Size of '$params{'file_name'}' ($file_size) exceeds "
                . "limit ($params{'max_size'})";
        }
    }

    my $self = {
        %params,
        fh     => $fh,
        logger => get_logger(),
    };

    return bless $self, $class;
}

sub extract_subtitles {
    my $self = shift;

    if ( $self->{'subtitles'} ) {
        return $self->{'subtitles'};
    }

    my $subtitles = $self->_extract_subtitles();
    $subtitles = $self->_strip_html_tags($subtitles);

    $self->{'subtitles'} = $subtitles;

    return $self->{'subtitles'};
}

#-------------------------------------------------------------------------------
#  Private methods
#-------------------------------------------------------------------------------

sub _strip_html_tags {
    my $self      = shift;
    my $subtitles = shift;

    my $hs = HTML::Strip->new();

    foreach my $subtitle ( @{$subtitles} ) {

        # inplace replacement ($subtitle is a alias not a copy)
        $subtitle = $hs->parse($subtitle);
        $hs->eof();
    }

    return $subtitles;
}

1;
