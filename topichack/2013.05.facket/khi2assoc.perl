#---------
my $bg = "bakgrund.txt";
my $fn = "nyall.txt";
my $stoplist = "stoplist.sv";
my $debug = 1;
my $threshold = 10;
my $minafreq = 10;
#---------
if ($debug) {
    $bg = "bakgrund.txt.head";
    $fn = "nyall.txt.head";
    $threshold = 0;
    $minafreq = 0;
}
#---------
my %observation; # alla ord jag ser
my $tot; # antal ord jag sett
my %stop; #stoppord
my %tagglista; # alla taggar jag definierat
my %taggtot; # antal ord per tagg
my %taggcount; # ord per tagg
my %lhs; #v�nsterkontext
my %rhs; #h�gerkontext
#---------
if ($#ARGV >= 0) {$fn = $ARGV[0]; print "fn $fn\n";}
if ($#ARGV >= 1) {$bg = $ARGV[1];  print "bg $bg\n";}
if ($#ARGV >= 2) {$stoplist = $ARGV[2]; print "sl $stoplist\n";}
if ($#ARGV >= 3) {$debug = $ARGV[3]; print "debug\n";}
#---------
open STOPLIST, $stoplist;
while (<STOPLIST>) {
    chomp;
    $stop{$_} = 1;  
}
close STOPLIST;
#=================================================================
open BACKGROUND, $bg;
while (<BACKGROUND>) {
    $tagg = "bakgrund";
    chomp; 
    tr/A-Z/a-z/;
    s/:\-?\)/SMILEY/g;
    s/:\-?\(/SURSMILEY/g;
    s/[\'\:\/\.\;\?\-\,\(\)\!\"]/\ /g;
    @words = split;
    foreach (@words) {
	next if $_ > 0; #siffra
	next unless $_; # det var inget ord d�r
	next if $stop{$_};
	$observation{$_}++; # hur m�nga g�nger har vi sett detta ord?
	$tot++; # hur m�nga ord har vi sett?
    }
} 
close BACKGROUND;
open DATA, $fn;
while (<DATA>) {
    $tagg = "aktuell";  #komplicera h�r om flera taggar eller m�lord ska separeras vid observation
    chomp; 
    tr/A-Z/a-z/;
    $tagglista{$tagg}++;
    s/:\-?\)/SMILEY/g;
    s/:\-?\(/SURSMILEY/g;
    s/[\/\.\;\?\-\,\(\)\!\"]/\ /g;
    @words = split;
    foreach (@words) {
	next if $_ > 0; #siffra
	next unless $_; # det var inget ord d�r
	next if $stop{$_};
	$taggcount{$tagg}{$_}++;   # det h�r ordet f�rekom en g�ng i samma rad som taggen ifr�ga
	$taggtot{$tagg}++; # hur m�nga ord har den h�r taggen sett?
	$observation{$_}++; # hur m�nga g�nger har vi sett detta ord?
	$tot++; # hur m�nga ord har vi sett?
#	if ($tagg ne "background") { # g�r detta endast om det �r en m�lrad
	$lhs{$_}{$prev}++ if $prev;
	$rhs{$prev}{$_}++ if $prev;
#	    }
	$prev = $_ 
    }
    $prev = "";
} #klar med inl�sning nu r�knar vi
close DATA;
#=================================================================
# tag bort enkelf�rekomster s� blir livet lite enklare
foreach (keys %observation) {
    if ($observation{$_} == 1) {
	delete $observation{$_}; # ta bort den
	$tot--; # d� har vi ett ord f�rre
	foreach my $what (keys %tagglista) { #kolla alla taggar
	    if ($taggcount{$what}{$_}) {  # fanns den med denna tagg?
		$taggcount{$what}{$_}--; # d� tar vi bort den 
		$taggtot{$what}--;  # och s� tar vi bort ett ord fr�n taggens ordr�knare
	    }
	}
    }
}
#=================================================================
# f�r varje ord vi sett, om den f�rekommit med taggen, k�r khi2 p� den. h�gt khi2 betyder ovanligt vanligt ord. 
my %khi2;
foreach my $o (keys %observation) {
    my $khi2;
    my $tecken;
    foreach my $what (keys %tagglista) {
	if ($taggcount{$what}{$o}) {
	    ($tecken, $khi2) = &khi2($taggtot{$what},$taggcount{$what}{$o},$observation{$o},$tot);
	    $khi2{$what}{$o} = $tecken*$khi2 if $tecken > 0 && $khi2 > 7.78; # spara om khi2 �r tillr�ckligt stor (p > .90) och om ordet �r vanligare �n f�rv�ntat
	}
    }
}
# nu har sparat vi i %khi2 f�r varje tagg varje ord som har ett intressant khi2v�rde s�: $khi2{tagg}{ord}

# h�r �r de tjugo skevaste orden f�r varje tagg
foreach my $what (keys %tagglista) {
    foreach my $ord ( ( sort {$khi2{$what}{$b} <=> $khi2{$what}{$a}} keys %{$khi2{$what}})[0..20]) {
	$notable{$ord}++;
      	$skev{$what}{$ord}++;
    }
}
#=================================================================
# associationer mellan de skevaste orden och andra termer. d� f�r vi ta in data igen.
my %akhi2;
my %acount;
my %aobs;
my $tot2;
open DATA, $fn;
while (<DATA>) {
    chomp; 
    tr/A-Z/a-z/;
    $tagglista{$tagg}++;
    s/:\-?\)/SMILEY/g;
    s/:\-?\(/SURSMILEY/g;
    s/[\/\.\;\?\-\,\(\)\!\"]/\ /g;
    my @words = split;
    foreach my $x (@words) {
	next if $_ > 0; #siffra
	next unless $x; # det var inget ord d�r
	next if $stop{$x};
	$tot2++; # hur m�nga ord har vi sett?
	$aobs{$x}++; # hur m�nga g�nger har vi sett detta ord?
	if ($notable{$x}) { # nu tittar vi p� redan funna skeva ord. �r x ett s�dant ord?
	    foreach my $a (@words) { # d� kollar vi alla ord i raden en g�ng till
		next if $a > 0; #siffra
		next if $stop{$a};
		next if $a eq $x;
		$acount{$x}{$a}++;   # ord a f�rekom en g�ng i samma rad som det skeva ordet x.
	    }
	}
    }
}
close DATA;

# och k�r khi2 igen
foreach my $assoc (keys %notable) { # d� tar vi alla skeva ord
    my $akhi2;
    my $atecken;
    foreach my $o (keys %aobs) {
	next unless $acount{$assoc}{$o} > $minafreq;
	($atecken, $akhi2) = &khi2($aobs{$assoc},$acount{$assoc}{$o},$aobs{$o},$tot2);
	$akhi2{$assoc}{$o} = $atecken*$akhi2 if $atecken > 0 && $akhi2 > 7.78; # spara om khi2 �r tillr�ckligt stor (p > .90) och om ordet �r vanligare �n f�rv�ntat
    }
}
# nu har sparat vi i %akhi2


my %askew;
# h�r �r de tjugo skevaste orden f�r varje association
foreach my $assoc (keys %notable) {
    foreach my $ord ( ( sort {$akhi2{$assoc}{$b} <=> $akhi2{$assoc}{$a}} keys %{$akhi2{$assoc}})[0..20]) {
      	$askew{$assoc}{$ord}++;
    }
}
#=================================================================
foreach my $what (keys %tagglista) {
    print "$what -----------------------------------\n";
    foreach my $ord ( keys %{$skev{$what}}) {
  	print "\t$ord\t$taggcount{$what}{$ord}\t$observation{$ord}\t$khi2{$what}{$ord}\n" if $ord;
	foreach my $assass ( keys %{$askew{$ord}} ) {
	    print "\t\t$assass\n";
	}
	my $bg = "";
  	for $w ( ( sort {$lhs{$ord}{$b} <=> $lhs{$ord}{$a}} keys %{$lhs{$ord}})[0..3] )  {
  	    $bg .= "\t\t$w $ord\n" if $w && $lhs{$ord}{$w} > $threshold;
	}
	print "\tbigrams: [\n".$bg."\t\t]\n" if $bg;
	print "]\n";
    }
}
exit;
#=================================================================
sub khi2 {
    my ($spaltsumma,$rad_spalt_0_0,$radsumma,$total) = @_;
    my $ev = ($spaltsumma * $radsumma) / $total;
    my $skilln = $rad_spalt_0_0 - $ev;
    my $tecken = $skilln < 0 ? -1 : 1;
    my $khi2 = 0;
    $khi2 = (abs $skilln**2) / $ev if $ev;
    return $tecken, $khi2;
}

