my $chithreshold = 0; #7.78;
my $relevantcategory = "3";
my $criterionfield = 15;
my $classfield = 16;
while (<>) {
    @f = split;
    if ($f[$criterionfield] eq $relevantcategory) {$d{$f[$classfield]}++; $pos++;} else {$e{$f[$classfield]}++; $neg++;}
    $h{$f[$classfield]}++;
}

$tot = $pos + $neg;
for $key (keys %d) {
    $nond = 0;
    $none = 0;
    $nonh = 0;
    for $okey (keys %d) {
	$nond += $d{$okey};
	$none += $e{$okey};
	$nonh += $h{$okey};
    }
    ($tkn,$khi2,$ev) = &chi2($pos,$d{$key},$h{$key},$tot);
    print "rel\t| $key\t other\t | sum\n";
    print "------------------------------\n";
    print "$relevantcategory\t| $d{$key} \t $e{$key} \t| $h{$key}\n";
    print "other\t| $nond \t $none \t| $nonh\n";
    print "------------------------------\n";
    print "\t$pos\t$neg\t| $tot\n";
    print "------------------------------\n";
    print "khi2\t$ev\t$khi2\t$tkn\n";
    print "==============================\n";
}



exit;


sub chi2 {
    my ($spaltsumma,$rad_spalt_0_0,$radsumma,$total) = @_;
    my $ev = ($spaltsumma * $radsumma) / $total;
    my $skilln = $rad_spalt_0_0 - $ev;
    my $tecken = $skilln < 0 ? -1 : 1;
    my $chi2 = 0;
    $chi2 = (abs $skilln**2) / $ev if $ev;
    return $tecken, $chi2, $ev;
}

