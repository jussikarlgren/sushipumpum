#!/usr/bin/perl


while(<>) {
    next if /^<\?xml/;
    next if /^<documents numdocs/;
    next if m-</documents>-;
    if (/^<document/) {$i++;};
    print;
}
print "</documents>\n";

print STDERR "Kopiera dessa följande två rader och lägg dem först i filen!\n";
print STDERR "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print STDERR "<documents numdocs=\"$i\">\n";
