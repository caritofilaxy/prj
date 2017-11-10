package SS::Subtitle::Parser::SRT;

#===============================================================================
#     REVISION:  $Id: SRT.pm 192 2012-01-10 22:36:13Z xdr.box@gmail.com $
#  DESCRIPTION:  SubRip (SRT) subtitle format parser
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#     SEE ALSO:  http://en.wikipedia.org/wiki/SubRip
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 192 $) [1];

use base qw(SS::Subtitle::Parser::Base);

use English qw( -no_match_vars );
use Carp;

#use Smart::Comments;

Readonly my $TIME_RE       => qr/\d{2}:\d{2}:\d{2}(?:,\d*)?/xms;
Readonly my $TIME_RANGE_RE => qr/\A$TIME_RE\s-->\s$TIME_RE\z/xms;

#-------------------------------------------------------------------------------
#  Private methods
#-------------------------------------------------------------------------------

# Code snippets are taken from http://search.cpan.org/perldoc?Video::Subtitle::SRT
sub _extract_subtitles {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    my $fh = $self->{'fh'};

    binmode $fh, ':raw:eol(LF)'
        or confess 'Cannot setup PerlIO layers';

    local $RS = qq{\n\n};

    my @subtitles = ();

    my $subtitles_processed = 0;
    my $subtitles_parsed    = 0;
    my $subtitles_skipped   = 0;

    my $max_subtitles = $self->{'max_subtitles'};

CHUNK:
    while ( my $chunk = <$fh> ) {
        my @chunk = split /\r?\n/xms, $chunk;
        my $subtitle = $self->_extract_subtitle( \@chunk );

        if ($subtitle) {
            $subtitles_parsed++;
            push @subtitles, $subtitle;
        }
        else {
            $subtitles_skipped++;
        }

        $subtitles_processed++;

        if ( $max_subtitles > 0 && $subtitles_processed >= $max_subtitles ) {
            $self->{'logger'}
                ->warn("Max subtitles limit ($max_subtitles) reached");
            last CHUNK;
        }
    }

    ## no critic (ProhibitParensWithBuiltins)
    $self->{'logger'}->debug(
        'Subtitles processed/parsed/skipped: '
            . join( q{/},
            $subtitles_processed, $subtitles_parsed, $subtitles_skipped )
    );
    ## use critic

    return \@subtitles;
}

sub _extract_subtitle {
    my $self  = shift;
    my $chunk = shift;

    ## no critic (ProhibitMagicNumbers)
    if ( @{$chunk} < 3 ) {
        $self->{'logger'}->debug('At least 3 lines expected in the chunk');
        return;
    }
    ## use critic

    if ( $chunk->[0] !~ /\A\d+\z/xms ) {
        $self->{'logger'}
            ->debug("Subtitle number expected, but found: '$chunk->[0]'");
        return;
    }

    if ( $chunk->[1] !~ $TIME_RANGE_RE ) {
        $self->{'logger'}->debug("Invalid time range format: '$chunk->[1]'");
        return;
    }

    ## no critic (ProhibitDoubleSigils)
    my $subtitle = join q{ }, @{$chunk}[ 2 .. $#$chunk ];
    ## use critic

    $subtitle =~ s/\A\s+//xms;
    $subtitle =~ s/\s+\z//xms;

    return $subtitle;
}

1;
