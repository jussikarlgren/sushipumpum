#!/usr/bin/perl

while(<>) {
    split;
    next if $_[2] eq "NUM";
    next if $_[2] eq "ADV" && substr($_[1],-5) eq "mente";
    print "$_[1]\n";
};
