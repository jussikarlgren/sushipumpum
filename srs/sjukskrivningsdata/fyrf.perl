while (<>) {
@f = split;
if ($f[15] eq "3") {$d{$f[16]}++; $n++;} else {$e{$f[16]}++; $notn++;}
}

for $k (keys %d) {
    print "$k\t$d{$k}\t$e{$k}\n";
}

print "\t$n\t$notn\n";
