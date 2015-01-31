#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade tt-filer och expanderar sammansättningar till 
# olika möjliga delar i dem för att göra gsdm-indexering mer komplett.


while (<>) {                                      
    next if (m=^<=);                              # strunta i taggar
    next if  m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
   s¤[\n\'\*\-]¤¤g;
   s¤[\#]¤¤g;
    next if $_ eq "";                         # ta bort tomma morfem
    tr/A-ZÅÄÖ/a-zåäö/;                 # stora bokstäver till små
    print ;                    # skriv ut den bara
    print "\n";
};
