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
for $key (keys %f) {
    $nond = 0;
    $none = 0;
    $nonh = 0;
    for $okey (keys %f) {
	$nond += $d{$okey};
	$none += $e{$okey};
	$nonh += $h{$okey};
    }
    $khi2 = &chi2($pos,$d{$key},$h{$key},$tot);
    print "rel\t| $key\t other\t | sum\n";
    print "------------------------------\n";
    print "$relevantcategory\t| $d{$key} \t $e{$key} \t| $h{$key}\n";
    print "other\t| $nond \t $none \t| $nonh\n";
    print "------------------------------\n";
    print "\t$pos\t$neg\t| $tot\n";
    print "------------------------------\n";
    print "khi2\t$khi2\n";
    print "==============================\n";
}






  	print "\t$ord ($chi2{$what}{$ord}; $taggcount{$what}{$ord}; $tagglinecount{$what}{$ord}; $linecount{$ord})\n";
	my $bigramstring = "";
  	for $w ( ( sort {$lhs{$ord}{$b} <=> $lhs{$ord}{$a}} keys %{$lhs{$ord}})[0..3] )  {
  	    $bigramstring .= "\t\t$w $ord\n" if $w && $lhs{$ord}{$w} > 10;
  	}
	if ($bigramstring) {
	print "\tbigrams: [\n";
	print $bigramstring;
	print "\t\t]\n";
	}
	my $relfocterm = "";
  	foreach my $annatord (sort {$closeness{$what}{$ord}{$b} <=> $closeness{$what}{$ord}{$a}} keys %{$closeness{$what}{$ord}}) {
  	    $relfocterm .= "$annatord, " if $closeness{$what}{$ord}{$annatord} > 10;
  	}
	if ($relfocterm) {
	    print "\t\trelated focus terms: [ ";
	    print $relfocterm;
	    print "]\n";
	}

    }
}

exit;


sub chi2 {
    my ($spaltsumma,$rad_spalt_0_0,$radsumma,$total) = @_;
    my $ev = ($spaltsumma * $radsumma) / $total;
    my $skilln = $rad_spalt_0_0 - $ev;
    my $tecken = $skilln < 0 ? -1 : 1;
    my $chi2 = 0;
    $chi2 = (abs $skilln**2) / $ev if $ev;
    return $tecken, $chi2;
}

