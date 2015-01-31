#!/usr/bin/perl
# prefixes lines with $opt_p
# jussi
require "getopts.pl";
&Getopts('p:');
if ($opt_p) {
while (<>) {
    print "$opt_p $_";
}
} else {
    print "Usage: prefix.perl -p prefix filename\n";
    print "       To prefix every line of file filename with string prefix\n";

}
