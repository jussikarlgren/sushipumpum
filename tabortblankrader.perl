#!/usr/bin/perl

while (<>) {
    chop;
    s/^(\ )+//;
    if ($_ eq "") {$tomrad++;} else {$tomrad = 0;};	
    if ($tomrad > 1) {next;};
    print;
    print "\n";
};
