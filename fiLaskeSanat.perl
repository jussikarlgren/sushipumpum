#!/usr/bin/perl
# Jussi Karlgren Jan 2004 
# Räkna ord i connexor-processade finska aamufiler.
while (<>) {
    if (m/<docno=(AAMU[0-9]+-[0-9]+)>/) {      
	$docid = $1;
	print "$i\n";
	$i = 0;
	print "$1	";
    };	
    $inbusiness = 0 if m-</text>-;
    $i++ if $inbusiness;
    $inbusiness = 1 if m-<text>-;
}

	print "$docid	$i\n";
