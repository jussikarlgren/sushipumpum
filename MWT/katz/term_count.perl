#!/usr/local/bin/perl
while (<>) { $_ =~ split ; $cc++ if (@_[0] > 1); }; print $cc,"\n"; exit(0);

