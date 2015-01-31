#!/usr/bin/perl

while (<>) {
    chop;
    next if $_ eq "";
    $N++;
    split;
    %this = ();
    foreach (@_) {
	$c = lc $_;
	$df{$c}++ unless $this{$c};
	$this{$c}++;
	$tf{$c}++;
    }
    foreach (keys %this) {
	if ($this{$_} > 1) {$nT{$_}++;}
	if ($this{$_} == 1) {$n1{$_}++;}
#	print "$_\t$this{$_}\t($tf{$_}-$n1{$_})/$nT{$_};  ...\n";
    }
}
foreach (keys %df) {
    $alpha=($nT{$_}+$n1{$_})/$N;
    $gamma=1-$n1{$_}/($nT{$_}+$n1{$_});
    if ($nT{$_} > 0) {
	$Burst=($tf{$_}-$n1{$_})/$nT{$_};
#	print "$_\t$Burst=($tf{$_}-$n1{$_})/$nT{$_}; --\n";
    } else {
	$Burst = 0;
    }
    print "$_	$alpha	$gamma	$Burst\n";
}

