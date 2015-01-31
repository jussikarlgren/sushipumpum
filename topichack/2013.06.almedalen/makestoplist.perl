while (<>) {

    chomp; 
    tr/A-Z/a-z/;
    s/:\-?\)/SMILEY/g;
    s/:\-?\(/SURSMILEY/g;
    s/[\/\.\;\?\-\,\(\)\!\"]/\ /g;
    $lines++; 
    @words = split;
    foreach (@words) {
	$words++;
	$this{$_}++; # hur många gånger har vi sett detta ord?
    }
    foreach $k (keys %this) {$df{$k}++; }
    %this = ();
}


foreach $w ( (sort {$df{$b} <=> $df{$a}} keys %df)[0..100]) {
    print "$w\t$df{$w}\n";
}

