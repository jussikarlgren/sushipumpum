#!/usr/bin/perl

while (<>) {
    split;
    $tmp{$_[2]}++;
    if (eof) {
	$n++;
	foreach (keys %tmp) {
	    $freq{$_}++;
	}
	%tmp = ();
    }
}

foreach (keys %freq) {
    if ($freq{$_} > 1) {print $freq{$_}/$n ; print "	$_\n";}
}
