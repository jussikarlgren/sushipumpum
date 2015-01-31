#!/usr/bin/perl

print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print "<documents numdocs=\"142819\">\n";
while(<>) {
    if (/^<document/) {
	s=tt-orig/==g;
	s/xml\.fdg/xml/g;
	$i++; 
    }
    s/<Card>//g; # fdg-tagg som slunkit igenom
    if (m-<(\w+)>-) {print STDERR "a:$1 " if ($1 ne "section" || $1 ne "document");};
    if (s/([a-z]+):[><](\d+)//g) {print STDERR "b:$1 $2 ";}; # dito
    s/&/&amp;/g;
    print;
}
print "</documents>\n";
print STDERR "$i\n";


