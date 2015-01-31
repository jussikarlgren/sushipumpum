#!/usr/bin/perl

while(<>) {
print " ";
s-[\'\:;\.\(\)\,\"]--;
if (/^SDA/) {
print "\n";
split;
print $_[0];
print "\t";
} else {
split;
next if $_[2] eq "-";
next if $_[2] eq "d";
next if $_[2] eq "None";
if ($_[2] =~ m-<unknown>-) {print $_[0] ; next; } ;
if ($_[2] =~ m-(\w+)\|-) {print "$1 "; next;} 
print "$_[2] ";
}
}
