#!/usr/bin/perl


while(<>) {
    next if /^<\?xml/;
    next if /^<documents numdocs/;
    next if m-</documents>-;
    if (/^<document/) {$i++;};
    print;
}
print "</documents>\n";

print STDERR "Kopiera dessa f�ljande tv� rader och l�gg dem f�rst i filen!\n";
print STDERR "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print STDERR "<documents numdocs=\"$i\">\n";
