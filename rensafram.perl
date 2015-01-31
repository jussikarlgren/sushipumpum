#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade tt-filer och expanderar sammans�ttningar till 
# olika m�jliga delar i dem f�r att g�ra gsdm-indexering mer komplett.


while (<>) {                                      
    next if (m=^<=);                              # strunta i taggar
    next if  m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
   s�[\n\'\*\-]��g;
   s�[\#]��g;
    next if $_ eq "";                         # ta bort tomma morfem
    tr/A-Z���/a-z���/;                 # stora bokst�ver till sm�
    print ;                    # skriv ut den bara
    print "\n";
};
