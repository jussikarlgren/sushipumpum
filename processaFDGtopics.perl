#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade s�kfr�ge-filer och expanderar sammans�ttningar till 
# olika m�jliga delar i dem f�r att g�ra gsdm-indexering mer komplett.

open(STOPLIST, "</hosts/krumelur/e2/clef/bin/stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;


while (<>) {                                      
    print "\n" if (m-[Cc]\d\d\d-);                   # mata ut radbrytning vid fr�genummer
    next if (m=^<=);                              # strunta i taggar
    split;                                        # bryt raden vid varje tab - det �r ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
    next if $stop{$lemma};
    $lemma =~ s�[\'\*\-]��g;
    $lemma =~ s�[\#]��g;
    next if $lemma eq "";                         # ta bort tomma morfem
    $lemma  =~ tr/A-Z���/a-z���/;                 # stora bokst�ver till sm�
    print "$lemma ";                    # skriv ut den bara
};
