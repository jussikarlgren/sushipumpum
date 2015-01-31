my %ord;
my %produkt; 
my %channel; 
my %retailer; 
my $lines;
my %lines;
my %tagglista;
my %taggcount;
my %taggtot;
my %observation;
my $tot;
    open(STOPLIST, "stoplist.sv");  
    while ($_ = <STOPLIST>) {
	($str = $_) =~ s/\s//; 
	$str =~ tr/A-Z/a-z/;  
	$stop{$str} = 1;  
    }
    close STOPLIST;

open BACKGROUND, "bakgrund.txt";
while (<BACKGROUND>) {
    $produkt = background; $channel=background; $retailer=background; #basfallet
    chomp; 
    @words = map {lc} split;
    foreach (@words) {
	next unless $_; # det var inget ord där
	next if $stop{$_};
	$observation{$_}++; # hur många gånger har vi sett detta ord?
	$tot++; # hur många ord har vi sett?
    }
    $lines++;  # hur många rader har vi sett (används inte just nu)
} 
close BACKGROUND;
open DATA, "nyall.txt";
while (<DATA>) {
    $produkt = background; $channel=background; $retailer=background; #basfallet
    # kolla vilka taggar det finns på raden istället för basfallet om det är så att
    if (/TELE2PRODUKT_([\w_]+)\tTELE2SALESCHANNEL_([\w_]+)\tTELE2RETAILERNAME_([\w_]+)/) {
	$produkt = $1; $channel=$2; $retailer=$3;
	$tagglista{$produkt}++;
	$tagglista{$channel}++;
	$tagglista{$retailer}++;
    }
    chomp; 
    @words = map {lc} split;
    foreach (@words) {
	next unless $_; # det var inget ord där
	next if /tele2\w+/; # det var en tagg, den ska inte räknas
	next if $stop{$_};
	$taggcount{$produkt}{$_}++;   # det här ordet förekom en gång i samma rad som taggen ifråga
	$taggcount{$channel}{$_}++;
	$taggcount{$retailer}{$_}++;
	$taggtot{$channel}++; # hur många ord har den här taggen sett?
	$taggtot{$retailer}++;
	$taggtot{$produkt}++;
	$observation{$_}++; # hur många gånger har vi sett detta ord?
	$tot++; # hur många ord har vi sett?
	    if ($produkt ne background) { # gör detta endast om det är en målrad
		$lhs{$_}{$prev}++ if $prev; # {$produkt} om vi vill specialisera! this'll do for now.
		$rhs{$prev}{$_}++ if $prev;
	    }
	    $prev = $_ 
    }
    $prev = "";
    $lines{$produkt}++; # det var en rad till för denna tagg (används inte just nu)
    $lines{$channel}++; 
    $lines{$retailer}++; 
    $lines++;  # hur många rader har vi sett (används inte just nu)
} #klar med inläsning nu räknar vi
close DATA;

# tag bort enkelförekomster så blir livet lite enklare
foreach (keys %ord) {
    if ($observation{$_} == 1) {
	delete $observation{$_}; # ta bort den
	$tot--; # då har vi ett ord färre
	foreach my $what (keys %tagglista) { #kolla alla taggar
	    if ($taggcount{$what}{$_}) {  # fanns den med denna tagg?
		$taggcount{$what}{$_}--; # då tar vi bort den 
		$taggtot{$what}--;  # och så tar vi bort ett ord från taggens ordräknare
	    }
	}
    }
}


# för varje ord vi sett, om den förekommit med taggen, kör chi2 på den. högt chi2 betyder ovanligt vanligt ord. 
my %chi2;
foreach my $o (keys %observation) {
    my $chi2;
    my $tecken;
    foreach my $what (keys %tagglista) {
	if ($taggcount{$what}{$o}) {
	    ($tecken, $chi2) = &chi2($taggtot{$what},$taggcount{$what}{$o},$observation{$o},$tot);
	    $chi2{$what}{$o} = $tecken*$chi2 if $tecken > 0 && $chi2 > 7.78; # spara om chi2 är tillräckligt stor (p > .90) och om ordet är vanligare än förväntat
	    $candidates{$o}++  if $tecken > 0 && $chi2 > 7.78; # slösaktigt men bekvämt
	}
    }
}
# nu har sparat vi i %chi2 för varje tagg varje ord som har ett intressant chi2värde så: $chi2{tagg}{ord}


# här är de tjugo skevaste orden för varje tagg
foreach my $what (keys %tagglista) {
    foreach my $ord ( ( sort {$chi2{$what}{$b} <=> $chi2{$what}{$a}} keys %{$chi2{$what}})[0..20]) {
	$notable{$ord}++;
      	$topical{$what}{$ord}++;
      	$skev{$what}{$ord}++;
    }
}

# associationer mellan associationer. då får vi ta in data igen.
open DATA, "nyall.txt";
my %assoc;
my %nobservation;
while (<DATA>) {
    chomp; 
    my @words = map {lc} split;
    foreach my $x (@words) {
	next unless $notable{$x};
	foreach my $y (@words) {
	    next if $y eq $x;
	    foreach my $what (keys %tagglista) {
		next unless $topical{$what}{$y};
		$nobservation{$y}++;
		$assoc{$what}{$x}{$y}++;
	    }
	}
    }
} #klar med inläsning nu räknar vi
close DATA;
foreach my $ord (keys %nobservation) {
    foreach my $what (keys %tagglista) {
	foreach my $annatord ( ( sort {$assoc{$what}{$ord}{$b} <=> $assoc{$what}{$ord}{$a}} keys %{$assoc{$what}{$ord}})[0..20]) {
	    $closeness{$what}{$ord}{$annatord} += $assoc{$what}{$ord}{$annatord} if $annatord;
	}
    }
}
foreach my $what (keys %tagglista) {
    print "$what -----------------------------------\n";
    foreach my $ord ( keys %{$skev{$what}}) {
  	print "\t$ord\n" if $ord;
	print "\tbigrams: [\n";
  	for $w ( ( sort {$lhs{$ord}{$b} <=> $lhs{$ord}{$a}} keys %{$lhs{$ord}})[0..3] )  {
  	    print "\t\t$w $ord\n" if $w && $lhs{$ord}{$w} > 10;
  	}
	print "\t\t]\n";
	print "\t\trelated focus terms: [ ";
  	foreach my $annatord (sort {$closeness{$what}{$ord}{$b} <=> $closeness{$what}{$ord}{$a}} keys %{$closeness{$what}{$ord}}) {
  	    print "$annatord " if $closeness{$what}{$ord}{$annatord} > 10;
  	}
	print "]\n";
# strunta i efterkommande ord just nu för de verkar inte så bra
#  #	for $w ( ( sort {$rhs{$ord}{$b} <=> $rhs{$ord}{$a}} keys %{$rhs{$ord}})[0..3] )  {
#  #	    print "\t\t$ord $w\t$rhs{$ord}{$w}\n" if $w && $lhs{$ord}{$w} > 10;
#  #	}
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

