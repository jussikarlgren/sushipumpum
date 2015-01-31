#!/usr/bin/perl

@vowels = ("a","e","i","o","u","y","å","ä","ö");
@consonants = ("m","n","nt","rt","st","nd","l","k","g");

foreach $v (@vowels) {
foreach $c (@consonants) {
foreach $w (@vowels) {
print $v.$c."i".$w."\n";
}
}
}


