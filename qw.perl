#!/usr/bin/perl
# plockar ut frågeord från gamla sökfrågor

while (<>) {
    s/[\.\-\?\!]//g;
    $eoq = 1 if m-</top>-;
    if ($eoq) {
	$n++;
	foreach (keys %tmp) {
	    $freq{$_}++;
	}
	%tmp = ();
	$eoq = 0;
	next;
    }

    split;
    foreach $w (@_) {    
	$x = lc $w;
	$tmp{$x}++ unless $x =~ m-<-;
    }
}
foreach (keys %freq) {
    if ($freq{$_} > 1) {print $freq{$_}/$n ; print "	$_\n";}
}
