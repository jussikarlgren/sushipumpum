#!/usr/bin/perl
$l = 0;
$f1 = $ARGV[0];
$N = 10;

open(F0,">$f1.part0");
open(F1,">$f1.part1");
open(F2,">$f1.part2");
open(F3,">$f1.part3");
open(F4,">$f1.part4");
open(F5,">$f1.part5");
open(F6,">$f1.part6");
open(F7,">$f1.part7");
open(F8,">$f1.part8");
open(F9,">$f1.part9");


#for ($i=0;$i<$N;$i++) {
#    eval (open(F$i , ">$f1.part$i"));
#}

while(<>) {
    if ($l == 0) {print F0 $_;}
    if ($l == 1) {print F1 $_;}
    if ($l == 2) {print F2 $_;}
    if ($l == 3) {print F3 $_;}
    if ($l == 4) {print F4 $_;}
    if ($l == 5) {print F5 $_;}
    if ($l == 6) {print F6 $_;}
    if ($l == 7) {print F7 $_;}
    if ($l == 8) {print F8 $_;}
    if ($l == 9) {print F9 $_;}
    $l++;
    $l = 0 if $l >= $N;
}

close(F0);
close(F1);
close(F2);
close(F3);
close(F4);
close(F5);
close(F6);
close(F7);
close(F8);
close(F9);
