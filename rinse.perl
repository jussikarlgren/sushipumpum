#!/usr/bin/perl
open(STOPLIST, "<stoplist.sv-fr");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;
while (<>) {
    split;
    $qno = shift @_;
    print "$qno		";
    foreach $w (@_) {
	next if $w =~ m/[\"\.\?\!\-,]/;
	$x = lc $w;
	print "$x " unless $stop{$x};
    };
    print "\n";
};
