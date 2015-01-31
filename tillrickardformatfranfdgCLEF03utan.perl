#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade tt-filer och expanderar sammansättningar till 
# olika möjliga delar i dem för att göra gsdm-indexering mer komplett.

#open(STOPLIST, "</hosts/krumelur/e2/clef/bin/stoplist.sv");  
#while (<STOPLIST>) {
#chop;
#    $stop{$_} = 1;  
#}
#close STOPLIST;
#


    print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
    print "<documents numdocs=\"1\">\n";
while (<>) {                                      
	if (m=^<DOCID>(TT9495-(\d+)-(\d+))</DOCID>=) {
	    print "<document type=\"newsprint\" name=\"$1\" date=\"$2\">\n";
	};
	if (m-^</DOC>-) {
	    print "\n</document>\n";
	};
    next if (m=^<=);                              # strunta i taggar
    split /\t/;                                        # bryt raden vid varje tab - det är ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
    next if $stop{$lemma};
    $lemma =~ s¤[\n\'\*\-]¤¤g;
    $lemma =~ s¤[\#]¤¤g;
    next if $lemma eq "";                         # ta bort tomma morfem
    $lemma  =~ tr/A-ZÅÄÖ/a-zåäö/;                 # stora bokstäver till små
    print "$lemma ";                    # skriv ut den bara
};
print "</documents>\n" if $indexrun;
