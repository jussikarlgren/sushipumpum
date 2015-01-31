#!/usr/bin/perl

open(NYCKELORD,">>nyckelord.de");
open(KORPUS,">>korpus.de");


while(<>) {
if (m-<DOCID>(.+)</DOCID>-) {$docid = $1;};
$nyckelord = 1 if /<KW>/ ;
$nyckelord = 0 if m-</KW>- ;
if (/<LD>/) { print KORPUS "$docid\t"; $text = 1;}
if (m-</DOC>-) { print KORPUS "\n\n"; $text = 0;}
next if m-^<-;
chop;
print NYCKELORD "$docid\t$_\n" if $nyckelord;
print KORPUS "$_ " if $text;

}
close NYCKELORD;
close KORPUS;
