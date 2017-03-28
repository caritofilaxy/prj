#!/usr/bin/perl

use v5.022;
use warnings;

my $prj = $ARGV[0];
$prj =~ s#$#.pl#;
my $content = <<'END_CONTENT';
#!/usr/bin/perl

use strict;
use warnings;
END_CONTENT


open(my $fh,'>',$prj) || die "Cant make new file: $!";
print $fh $content;
close($fh);
chmod 0755, $prj;

exec("/usr/bin/vim $prj");
