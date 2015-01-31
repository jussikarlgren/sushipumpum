#!/usr/bin/perl
print "Training set in $ARGV[0].train (90% of data)\n";
print "Test set in $ARGV[0].test (10% of data)\n";
open(TRAIN,">".$ARGV[0].".train");
open(TEST,">".$ARGV[0].".test");
while (<>) {
    if (rand() > 0.1) {print TRAIN $_;} else {print TEST $_;}
}
close(TRAIN);
close(TEST);
