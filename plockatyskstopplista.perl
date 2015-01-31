#!/usr/bin/perl

while(<>) {
    @rad = split("	");
    @tag = split(" ",$rad[2]);
    next if $tag[1] eq "N";
    next if $tag[1] eq "NUM";
    next if $tag[1] eq "A";
    next if $tag[1] eq "<Cmp>";
    next if $tag[1] eq "<Sup>";
    next if $tag[1] eq "ADV";
        if ($tag[1] eq "V" && $tag[0] ne "&AUX")    { next;} ;
    print "$rad[1]\n";
};
