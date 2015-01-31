#!/usr/bin/perl

$text = 0;
while(<>) {
    if (m-</HL>-) {
	$text = 0;
	$rubrik =~ s/\ +/\ /g;
	$rubrik =~ s/^\ //;
	print "$rubrik\n";
	$rubrik = "";
	next;
    }
    if (/<HL>/) {
	$text = 1;
	next;
    }
    next unless $text;
    s/[\.-]/\ /g;
    s/\&amp;/\ and\ /g;
    s/[,\?!;:]//g;
    chop;
    $rubrik .= " ".$_;
}
