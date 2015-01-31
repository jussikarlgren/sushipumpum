#!/usr/bin/perl

while (<>) {

split;
$q = shift @_;
$q+=140;
unshift @_ , $q;
$n = join ' ',@_;
print "$n\n";
};
