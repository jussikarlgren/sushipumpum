#!/usr/bin/perl

$docAntal = 0;

open(STOPLIST, "<stoplist.fi");  
while (<STOPLIST>) {
    chop;
    $stop{$_} = 1;  
}
close STOPLIST;

print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print "<documents numdocs=\"1\">\n";

while(<>) {
    if (m/<docno=(AAMU199\d\d\d\d\d-\d\d\d\d\d\d)>/) {
	$docno = $1;   
	$date = substr($docno,6,6);
	$location = $ARGV;
	print "<document type=\"newsprint\" name=\"$name\" date=\"$date\" location=\"$location\">\n";
	$docAntal++;
	next;
    };
    if (m-<text>-) {
	$text = 1;   
	next;
    };
    
    if (m-</doc>-) {
	print "</section>\n";
	print "</document>\n";
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




print "</documents>\n";

