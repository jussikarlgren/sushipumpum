#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
while ($fnr = <>) {
    chop $fnr;
$fnr =~ m/TT9495-(\d\d)(\d\d)(\d\d)-\d+/;
$y = $1;
$m = $2;
$d = $3;
open (FIL,"/hosts/krumelur/e2/clef/sv/tt-fdg/19$y/$m/$d/$fnr.xml.fdg");
    open (OFIL, ">$fnr.ord");
while (<FIL>) {                                      
    split;
    $lemma = $_[2];
    next if ($lemma =~ m=^<=);                              # strunta i taggar
    next if $lemma =~  m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
$lemma =~    s¤[\n\'\*\-]¤¤g;
$lemma =~    s¤[\#]¤¤g;
    next if $lemma eq "";                         # ta bort tomma morfem
$lemma =~     tr/A-ZÅÄÖ/a-zåäö/;                 # stora bokstäver till små
    print OFIL $lemma;                    # skriv ut den bara
    print OFIL "\n";
};
close OFIL;
close FIL;
};
