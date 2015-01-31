#!/usr/bin/perl

$docAntal = 0;

open(STOPLIST, "</src/harvahammas/clef/CLEF2004/stoplist.en");  
while (<STOPLIST>) {
    chop;
    $stop{$_} = 1;  
}
close STOPLIST;

#print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
#print "<documents numdocs=\"1\">\n";

#<DOCNO> LA010194-0001 </DOCNO>
#<DOCNO>
#1	<s>	<s>
#1	GH950102-000000	gh950102-000000	main:>0	@NH %NH N NOM SG
#</DOCNO>


while(<>) {
    if (m/<DOCNO> (LA\d\d\d\d\d\d-\d\d\d\d)/) {
	$docno = $1;   
	$date = substr($docno,6,2).substr($docno,2,2).substr($docno,4,2);
	$location = $ARGV;
	$docAntal++;
	next;
    };
    if (m-<HEADLINE>-) {
	$rubrik = 1;   
	next;
    };
    if (m-</HEADLINE>-) {
	$rubrik = 0;   
	next;
    };
    if (m-<TEXT>-) {
	$text = 1;   
	next;
    };
    if (m-</TEXT>-) {
	$text = 0;   
	next;
    };
    if (m-</DOC>-) {
	chop $name;
	chop $rubrikText;
	chop $brodText;
	if ($rubrikText || $brodText) {
	    print "<document type=\"newsprint\" name=\"$docno\" date=\"$date\" location=\"$location\">\n";
	    if ($rubrikText) {
		print "<section name=\"TITLE\">\n";
		print "$rubrikText\n";
		print "</section>\n";
	    };
	    if ($brodText) {
		print "<section name=\"TEXT\">\n";
		print "$brodText\n";
		print "</section>\n";
	    };
	    print "</document>\n";
	};
	$name="";
	$rubrikText="";
	$brodText="";
	next;
    };
    next unless ($text || $rubrik);
    @rad = split("\t");
    @tag = split(" ",$rad[4]);
    if ($rubrik && @tag) {
	$surf = $rad[1];
	$name=$name.$surf." ";
    };
    if ($tag[2] eq "<?>") {$pos = $tag[3];} else {$pos = $tag[2];}
    if ($pos eq "N" || $pos eq "V" || $pos eq "A" || $pos eq "ADV") {
	$lemma= $rad[2];
	next if $lemma eq "*";
	$lemma =~ s/(\w)\.$/$1/g; # remove punctuation (period - nondec)
	next if $stop{$lemma};
	if ($rubrik) {
	    $rubrikText=$rubrikText.$lemma." ";
	} else {
	    $brodText=$brodText.$lemma." ";
	};
    };
};    


#print "</documents>\n";
#print "antal: $docAntal\n";

