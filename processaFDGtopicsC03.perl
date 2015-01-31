#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade sökfråge-filer och expanderar sammansättningar till 
# olika möjliga delar i dem för att göra gsdm-indexering mer komplett.

open(STOPLIST, "</hosts/krumelur/e2/clef/bin/stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;


while (<>) {                                      
    print "\n" if (m-<p>-);                   # mata ut radbrytning vid nytt stycke
    next if (m-<p>-);                   # mata ut radbrytning vid nytt stycke
    print "\t" if (m-yyy-);                   # dummy faeltseparator
    next if (m-yyy-);                   # dummy faeltseparator
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
