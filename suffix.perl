#!/usr/bin/perl

while (<>) {
    split /\t/;
    next unless $_[0] > 0;
    $surf = $_[1];
    $lem =  $_[2];
    next if (length $lem < 1);
    next if (length $surf < 1);
    next if ($surf =~ m-\'-);
    $lem =~ tr/A-Z/a-z/;
    $surf =~ tr/A-Z/a-z/;
    $stam = substr($surf,0,length($lem));
    next unless $stam eq $lem;
    $suff = substr($surf,length($lem));
    $diff = (length $surf) - (length $lem);
    next if $diff == 0;
    print "$diff $surf $lem\n" if $diff < 1;
    $difftab{$diff}++;
    $sufftab{$suff}++;
};

#foreach $k (keys %difftab) {
#if ($k > 0) {
#   $tot += $difftab{$k};
#   $sum += $k*$difftab{$k};
#};
##print "$k $difftab{$k}\n";
#};
##print "av: $tot/$sum = ".$tot/$sum."\n";



foreach $k (keys %sufftab) {
print "$sufftab{$k} $k\n";
};
