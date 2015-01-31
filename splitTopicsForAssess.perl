#!/usr/bin/perl

$prev = "dummy";


while(<>) {
    split;
    if ($prev ne $_[0]) {
        $filename = "topic".$_[0];
        close (FIL);
        open (FIL,">$filename");
    };
    $prev = $_[0];
    print FIL;
}

 
