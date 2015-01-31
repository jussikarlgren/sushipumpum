#!/usr/bin/perl

open(TMP,">tmp");
while(<>) {
    s/&amp;//g;
    s/&//g;
    s/\*//g;
    $n++ if m-</document>-;
    print TMP $_;
};
close(TMP);
print "<?xml version='1.0' encoding='iso-8859-1' standalone=\"yes\"?>\n";
print "<documents numdocs=\"$n\">\n";
open(TMPI,"tmp");
while (<TMPI>) {print;};
close(TMPI);
print "</documents>\n";
