#open SSYK3, "</home/jussi/srs/ssyk3korning/lopnr-datum-ssyk3.txt";
#while (<SSYK3>) {
#    chomp;
#    ($lopnr,$datum,$ssyk3) = split "\t";
#    unless ($firstssyk3{$lopnr}) {$firstssyk3{$lopnr} = $ssyk3;} else {$multiple{$lopnr}++;}
#    $ssyk3{$lopnr}{$datum} = $ssyk3;
#}
#close SSYK3;


while (<>) {
    @fall = split "\t";
    $ssyk3 = $fall[100];
    $dettadatum = $fall[1];
    $prev = $lopnr;
    $lopnr = $fall[0];
    $ssyk3{$lopnr} = $ssyk3;
    if ($lopnr eq "lopnr") {print; next;}
    if ($lopnr ne $prev) {
	$prevssyk3 = $ssyk3{$prev};
	for $kejs (@buffert) {	# töm buffert
	    @kejsfall = split "\t", $kejs;
	    for ($step = 0; $step < 100; $step++) {
		print "$kejsfall[$step]\t";
	    }
	    print "$prevssyk3\t";
	    for ($step = 101; $step < 103; $step++) {
		print "$kejsfall[$step]\t";
	    }
	    print "\n";
	}
	@buffert = ();
    }
    if ($ssyk3 > 0) {
	for $kejs (@buffert) {	# töm buffert
	    @kejsfall = split "\t", $kejs;
	    for ($step = 0; $step < 100; $step++) {
		print "$kejsfall[$step]\t";
	    }
	    print "$ssyk3\t";
	    for ($step = 101; $step < 103; $step++) {
		print "$kejsfall[$step]\t";
	    }
	    print "\n";
	}
	@buffert = ();
	print;
    } else {
	push @buffert, $_; #lagra detta fall
    }
}







