#!/usr/bin/perl
# Jussi Karlgren
# Usage: randomLine.perl [-r n] filename; 0 <= n <= 1; prints the given fraction of lines in filename.
# n defaults to 0.1.
require "getopts.pl";
&Getopts('hr:');
if ($opt_h) {print "Usage: randomLine.perl [-r n] filename; 0 <= n <= 1; prints the given fraction of lines in filename.\n         (n defaults to 0.1)\n"; exit();} 
$fraction = 0.1;
if ($opt_r) {$fraction = $opt_r;}
while (<>) {
    print if (rand() <= $fraction);
}
