#!/usr/bin/perl
while (<>) {
    s/(<[^>]+>)//g;        # remove sgml/html tags
    s/&nbsp;/\ /g;
    s/\[\d+\]/\ /g;        # wiki refs
    lc;
    s/�//g;
    tr/��/a/;
    tr/��/a/;
    tr/��/a/;
    tr/��/a/;
    tr/��/o/;
    tr/��/o/;
    tr/A-Z/a-z/;
    s/\W/\ /g;
    s/\s+/\ /g;
    print;
    print "\n";
}

