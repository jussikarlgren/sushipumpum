#!/usr/bin/perl
# swedenmark.perl r�knar ut antalet vokaler, ord, och tecken i en fdg-processad fil
# f�r att svara p� en fr�ga john st�llde i november 2003.
# jussi@sics.se

while (<>) {
    print "$ip $ord $vokal $tecken\n" if (m-^</DOC>-);
   next if (m=^<=);                              # strunta i taggar
    split;                                        # bryt raden vid varje tab - det �r ett ord per rad
    $surf = $_[2];                               # andra spalten har ytformen
    $ip++ if $surf =~ m�[\.\?!,:;\=]�;
    next if $surf =~ m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
   $ord++;
   $tecken += length $surf;
#   print "$surf ";
   $surf =~ tr/A-Z���/a-z���/;
   $surf =~ s/\#//go; 
   $surf =~ s/tion/i/go; 
   $surf =~ s/sion/i/go; 
   $surf =~ s/[bcdfghjklmnpqrstvwxz]//go;  # nordisk konfiguration
#   print "$surf ";
   $vokal += length $surf;
#   print "$ord $vokal $tecken\n";
};
    print "$ip $ord $vokal $tecken\n";
