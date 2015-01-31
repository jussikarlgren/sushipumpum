#!/usr/bin/perl
while (<>) {
    s/(<[^>]+>)//g;        # remove sgml/html tags
    s/&nbsp;/\ /g;
    s/\[\d+\]/\ /g;        # wiki refs
    lc;
    s///g;
    tr/ä/a/;
    tr/å/a/;
    tr/Å/a/;
    tr/Ä/a/;
    tr/Ö/o/;
    tr/ö/o/;
    tr/A-Z/a-z/;
    s/\W/\ /g;
    s/\s+/\ /g;
    print;
    print "\n";
}

