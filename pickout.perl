#!/usr/bin/perl

open(H,"<2004.corrs");
while (<H>) {
    split;
    $in{$_[0]}++;
}
foreach $i (keys %in) {print "$i ";}
close(H);
open(I,"<tmp");
while(<I>) {
    split;
    print "$_[0] ";
    foreach $w (@_) {
	if ($in{$w}) {print "$w ";}
    }
    print "\n";
}
