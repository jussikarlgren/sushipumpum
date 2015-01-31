#!/usr/bin/perl
$_ = <>;
split;
$tp = $_[0];
$fn = $_[1];
$_ = <>;
split;
$fp = $_[0];
$tn = $_[1];

print "($tp/$fn)/($fp/$tn) ".($tp/$fn)/($fp/$tn)."\n";
