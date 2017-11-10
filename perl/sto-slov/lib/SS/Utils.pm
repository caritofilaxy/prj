package SS::Utils;

#===============================================================================
#     REVISION:  $Id: Utils.pm 43 2011-10-12 16:09:05Z xdr.box@gmail.com $
#  DESCRIPTION:  Commonly used utils
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;

use Readonly;
Readonly our $VERSION => qw($Revision: 43 $) [1];

use English qw( -no_match_vars );
use Data::Dumper;

#use Smart::Comments;

use base qw(Exporter);

our @EXPORT_OK = qw(
    check_SS_ROOT
    dump_compact
    dump_var
);

sub check_SS_ROOT {    ## no critic (Capitalization)
    if ( !$ENV{'SS_ROOT'} || !-d $ENV{'SS_ROOT'} ) {
        die "Please set SS_ROOT environment variable\n";
    }

    return;
}

sub dump_compact {
    my $var = shift;
    my $label = shift || 'VAR';

    my $d = Data::Dumper->new( [$var], [$label] );
    $d->Indent(0);

    return $d->Dump();
}

sub dump_var {
    my $var = shift;
    my $label = shift || 'VAR';

    return Data::Dumper->Dump( [$var], [$label] );
}

1;

