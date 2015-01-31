#!/usr/bin/perl
# swedenmark.perl r�knar ut antalet vokaler, ord, och tecken i en fdg-processad fil
# f�r att svara p� en fr�ga john st�llde i november 2003.
# jussi@sics.se

while (<>) {
    print "$ip $ord $vokal $tecken\n" if (m-^</doc>-);
   next if (m=^<=);                              # strunta i taggar
    split;                                        # bryt raden vid varje tab - det �r ett ord per rad
    $surf = $_[2];                               # andra spalten har ytformen
    $ip++ if $surf =~ m�[\.\?!,:;\=]�;
    next if $surf =~ m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
   $ord++;
   $tecken += length $surf;
#   print "$surf ";
   $surf =~ tr/A-Z���/a-z���/;
   $surf =~ s/ai/I/go; 
   $surf =~ s/�i/I/go; 
   $surf =~ s/�i/I/go; 
   $surf =~ s/ei/I/go; 
   $surf =~ s/oi/I/go; 
   $surf =~ s/ui/I/go; 
   $surf =~ s/yi/I/go; 
   $surf =~ s/ou/I/go; 
   $surf =~ s/uo/I/go; 
   $surf =~ s/y�/I/go; 
   $surf =~ s/au/I/go; 
   $surf =~ s/eu/I/go; 
   $surf =~ s/�y/I/go; 
   $surf =~ s/�y/I/go; 
   $surf =~ s/aa/U/go; 
   $surf =~ s/ee/U/go; 
   $surf =~ s/ii/U/go; 
   $surf =~ s/oo/U/go; 
   $surf =~ s/uu/U/go; 
   $surf =~ s/yy/U/go; 
   $surf =~ s/��/U/go; 
   $surf =~ s/��/U/go; 
   $surf =~ s/\#//go; 
   $surf =~ s/[bcdfghjklmnpqrstvwxz]//go;  # nordisk konfiguration
#   print "$surf ";
   $vokal += length $surf;
#   print "$ord $vokal $tecken\n";
};
    print "$ip $ord $vokal $tecken\n";

