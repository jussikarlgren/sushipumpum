#!/usr/local/bin/perl
print "<html>\n";
print "<pre>\n";
while (<>) {

s/�/&ouml\;/g;
s/�/&auml\;/g;
s/�/&aring;/g;
print;
};



print "</pre>\n";
print "</html>\n";
