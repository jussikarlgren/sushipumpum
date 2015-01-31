#!/usr/bin/perl
# Jussi Karlgren Jan 2004 
# Räkna ord i connexor-processade finska aamufiler.
$i = 100;
$j = 1000;
while (<>) {
    split;
    if ($j % 1001 == 0) {
	$i++;
	close(F);
	$j = 1;
	open (F,">topic$i");
    }
    print F "$i	Q0	0	Aamu	$_[0]	$j	$_[1]	-1	Clarity	321\n";
    $j++;
}
close(F);
