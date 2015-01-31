#!/usr/bin/perl
# swedenmark.perl räknar ut antalet vokaler, ord, och tecken i en fdg-processad fil
# för att svara på en fråga john ställde i november 2003.
# jussi@sics.se

while (<>) {
    print "$ip $ord $vokal $tecken\n" if (m-^</DOC>-);
   next if (m=^<=);                              # strunta i taggar
    split;                                        # bryt raden vid varje tab - det är ett ord per rad
    $surf = $_[2];                               # andra spalten har ytformen
    $ip++ if $surf =~ m¤[\.\?!,:;\=]¤;
    next if $surf =~ m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
   $ord++;
   $tecken += length $surf;
   if (length $surf > 2) {
       $e = chop $surf;
       if ($e eq "e") {$vokal--;};
   };
   $surf =~ tr/A-ZÅÄÖ/a-zåäö/;
   $surf =~ s/ee/i/go;  # engelsk konfiguration
   $surf =~ s/ea/i/go;  # engelsk konfiguration
   $surf =~ s/oo/u/go;  # engelsk konfiguration
   $surf =~ s/ou/u/go;  # engelsk konfiguration
   $surf =~ s/au/a/go;  # engelsk konfiguration
   $surf =~ s/ai/a/go;  # engelsk konfiguration
   $surf =~ s/tion/i/go;  # engelsk konfiguration
   $surf =~ s/sion/i/go;  # engelsk konfiguration
   $surf =~ s/[bcdfghjklmnpqrstvwxyz]//go;  # engelsk konfiguration
#   $surf =~ s/bcdfghjklmnpqrstvwxz//g;  # nordisk konfiguration
   $vokal += length $surf;

};

   print "$ip $ord $vokal $tecken\n";
