#!/usr/bin/perl

while(<>) {
    chop;
    if (m-^<num> (C\d\d\d) </num>-) {
	print "$1 ";
    };
    if (m=^<SV-title> ([\d\w\ \(\)-:δεφα?]+) </SV-title>=) {
	print "$1 ";
    };
    if (m=^<SV-desc>=) {
	$desc = "true";
	s/<SV-desc>//;
    };
    if (m=</SV-desc>=) {
	s=</SV-desc>==;
	print;
	print "\n";
	$desc = 0;
    };
    if ($desc) {
	print;
	print " ";
    };
};
