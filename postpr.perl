#!/usr/local/bin/perl
print "<html>\n";
print "<pre>\n";
while (<>) {

s/ö/&ouml\;/g;
s/ä/&auml\;/g;
s/å/&aring;/g;
print;
};



print "</pre>\n";
print "</html>\n";
