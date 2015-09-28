while (<>) {
    chomp;
    ($id, $field, $value) = split "\t";
    if ($field eq "diagnos") {$di = $value;}
    if ($field) {
	@w1 = split " ",$value;
	foreach $w (@w1) {
	    $this{$w}++;
	}
	foreach $ww (keys %this) {
	    $df{$ww}++;
		$rekn{$field}{$di}++;
		$rektf{$field}{$di}{$ww} += $this{$ww};
		$rekdf{$field}{$di}{$ww}++;
	}
    }
    $d{$di}++;
    $fields{$field}++;
    undef %this;
}



for $field (keys %fields) {
    for $di ("s82","f32") {
	print "$field $di $rekn{$field}{$di}\t";
	foreach $w (sort {$rektf{$field}{$di}{$a} <=> $rektf{$field}{$di}{$b}} keys %{ $rektf{$field}{$di} }) {
#	    print "$w:$rektf{$field}{$di}{$w}:$rekdf{$field}{$di}{$w} " if $rekdf{$field}{$di}{$w} > 1;
	    print "$w:".$rektf{$field}{$di}{$w}/$df{$w}." " if $df{$w};
	}
	print "\n";
    }
}
