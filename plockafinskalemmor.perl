#!/usr/bin/perl

open(STOPLIST, "<stoplist.fi");  
while (<STOPLIST>) {
    chop;
    $stop{$_} = 1;  
}
close STOPLIST;

while(<>) {
    if (m-<text>-) {
	$text = 1;   
	next;
    };
    
    if (m-</doc>-) {
	print "\n\n";
	next;
    };
    
    next unless $text;
    
    if (m-</text>-) {
	$text = 0;   
	next;
    };
    
    @rad = split("	");
    $lemma = $rad[2];
    @tag = split(" ",$rad[4]);
    if ($tag[1] eq "<?>") {$pos = $tag[2];} else {$pos = $tag[1];}
    if ($pos eq "N" || $pos eq "V" || $pos eq "A" || $pos eq "ADV") {
	if ($lemma =~ '#') {
	    $compound = $lemma;
	    @morfs = split("#",$lemma);
	    $compound =~ s/\#//g;
	    print "$compound ";
	    foreach $morf (@morfs) {
		$morf =~ s/-$//;
		print "$morf ";
		if ($morf =~ m/n$/) {
		    $morf =~ s/n$//;
		    print "$morf ";
		};
	    };
	} else {
	    print "$lemma ";
	};
    };
};

