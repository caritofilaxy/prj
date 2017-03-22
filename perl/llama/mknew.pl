#!/usr/bin/perl

use v5.022;
use warnings;

my $text = <<'END_TXT';
#!/usr/bin/perl

use v5.022;
use warnings;
END_TXT

my $prj = $ARGV[0];
$prj =~ s[$][.pl];
open(my $fh, '>', $prj) || die "Cant create new file: $!";
print $fh $text;
close($fh);
chmod 0755, $prj;

exec("/usr/bin/vim $prj");
