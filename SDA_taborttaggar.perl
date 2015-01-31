#!/usr/bin/perl
while (<>) {
    s/(<[^>]+>)//g;        # remove sgml/html tags
print;
}
