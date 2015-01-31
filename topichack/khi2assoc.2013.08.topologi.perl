# 2013 08 19 mod för topologihack
# jussi
#=================================================================
my $bg = "bakgrund.txt";
my $fn = "nyall.txt";
#my $stoplist = "stoplist88.sv";
my $debug = 0;
my $threshold = 10;
my $minafreq = 10;
my $minobsfreq = 5;
my $mincollfreq = 5;
my $antal = 100;
#=================================================================
if ($debug) {
#    $bg = "bakgrund.txt.head";
#    $fn = "nyall.txt.head";
    $threshold = 0;
    $minafreq = 0;
}
#=================================================================
my %observation; # alla ord jag ser
my $tot; # antal ord jag sett
my %stop; #stoppord
my %tagglista; # alla taggar jag definierat
my %taggtot; # antal ord per tagg
my %taggcount; # ord per tagg
my %lhs; #vänsterkontext
my %rhs; #högerkontext
#=================================================================
if ($#ARGV >= 0) {$fn = $ARGV[0];}
if ($#ARGV >= 1) {$bg = $ARGV[1]; }
if ($#ARGV >= 2) {$stoplist = $ARGV[2];}
if ($#ARGV >= 3) {$targetterms = $ARGV[3];}
open TARGETS, "<$targetterms";
$re = "start";
while (<TARGETS>) {
    chomp;
    $re .= "|".$_;  
}
close TARGET;
$RE = qr/$re/;

if ($debug) {
    print "debug\n";
    print "fn $fn\n";
    print "bg $bg\n";
    print "sl $stoplist\n";
    print "tg $targetterms\n";
    print "re $RE\n";
    print "th $threshold\n";
    print "fq $minafreq\n";
}

#=================================================================
unless ($stoplist eq "null") {
    open STOPLIST, $stoplist;
    while (<STOPLIST>) {
	chomp;
	$stop{$_} = 1;  
    }
    close STOPLIST;
}
#=================================================================

open DATA, $fn;
while (<DATA>) {
    @fangst = /($RE)/g;
    chomp; 
    tr/A-Z/a-z/;
    s/[\”\ \/\.\;\?\-\,\(\)\!\"]/\ /g;

    if (@fangst > 0) {
    for $tagg (@fangst) {
    chomp; 
    $tagglista{$tagg}++;
    @words = split;
    foreach (@words) {
	next if $_ > 0; #siffra
	next unless $_; # det var inget ord där
	next if $stop{$_};
	$taggcount{$tagg}{$_}++;   # det här ordet förekom en gång i samma rad som taggen ifråga
	$taggtot{$tagg}++; # hur många ord har den här taggen sett?
	$observation{$_}++; # hur många gånger har vi sett detta ord?
	$tot++; # hur många ord har vi sett?
#lr	$lhs{$_}{$prev}++ if $prev;
#lr	$rhs{$prev}{$_}++ if $prev;
#lr	$prev = $_ 
    }
#lr    $prev = "";
    }
    } else {
    @words = split;
    foreach (@words) {
	next if $_ > 0; #siffra
	next unless $_; # det var inget ord där
	next if $stop{$_};
	$observation{$_}++; # hur många gånger har vi sett detta ord?
	$tot++; # hur många ord har vi sett?
    }
    }
} #klar med inläsning nu räknar vi
close DATA;
#print $tot;
#=================================================================
# tag bort enkelförekomster så blir livet lite enklare
foreach (keys %observation) {
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
#=================================================================
# för varje ord vi sett, om den förekommit med taggen, kör khi2 på den. högt khi2 betyder ovanligt vanligt ord. 
my %khi2;
foreach my $o (keys %observation) {
    my $khi2;
    my $tecken;
    foreach my $what (keys %tagglista) {
	if ($taggcount{$what}{$o}) {
	    ($tecken, $khi2) = &khi2($taggtot{$what},$taggcount{$what}{$o},$observation{$o},$tot);
	    $khi2{$what}{$o} = $tecken*$khi2 if $tecken > 0 && $khi2 > 7.78; # spara om khi2 är tillräckligt stor (p > .90) och om ordet är vanligare än förväntat
	}
    }
}
# nu har sparat vi i %khi2 för varje tagg varje ord som har ett intressant khi2värde så: $khi2{tagg}{ord}

# här är de $antal skevaste orden för varje tagg
foreach my $what (keys %tagglista) {
    foreach my $ord ( ( sort {$khi2{$what}{$b} <=> $khi2{$what}{$a}} keys %{$khi2{$what}})[0..$antal]) {
	$notable{$ord}++;
      	$skev{$what}{$ord}++;
    }
}
#=================================================================
# associationer mellan de skevaste orden och andra termer. då får vi ta in data igen.
my %akhi2;
my %acount;
my %aobs;
my $tot2;
# null assass --  open DATA, $fn;
# null assass --  while (<DATA>) {
# null assass --      chomp; 
# null assass --      tr/A-Z/a-z/;
# null assass --      $tagglista{$tagg}++;
# null assass --      s/:\-?\)/SMILEY/g;
# null assass --      s/:\-?\(/SURSMILEY/g;
# null assass --      s/[\/\.\;\?\-\,\(\)\!\"]/\ /g;
# null assass --      my @words = split;
# null assass --      foreach my $x (@words) {
# null assass --  	next if $_ > 0; #siffra
# null assass --  	next unless $x; # det var inget ord där
# null assass --  	next if $stop{$x};
# null assass --  	$tot2++; # hur många ord har vi sett?
# null assass --  	$aobs{$x}++; # hur många gånger har vi sett detta ord?
# null assass --  	if ($notable{$x}) { # nu tittar vi på redan funna skeva ord. är x ett sådant ord?
# null assass --  	    foreach my $a (@words) { # då kollar vi alla ord i raden en gång till
# null assass --  		next if $a > 0; #siffra
# null assass --  		next if $stop{$a};
# null assass --  		next if $a eq $x;
# null assass --  		$acount{$x}{$a}++;   # ord a förekom en gång i samma rad som det skeva ordet x.
# null assass --  	    }
# null assass --  	}
# null assass --      }
# null assass --  }
# null assass --  close DATA;
# null assass --  
# null assass --  # och kör khi2 igen
# null assass --  foreach my $assoc (keys %notable) { # då tar vi alla skeva ord
# null assass --      my $akhi2;
# null assass --      my $atecken;
# null assass --      foreach my $o (keys %aobs) {
# null assass --  	next unless $acount{$assoc}{$o} > $minafreq;
# null assass --  	($atecken, $akhi2) = &khi2($aobs{$assoc},$acount{$assoc}{$o},$aobs{$o},$tot2);
# null assass --  	$akhi2{$assoc}{$o} = $atecken*$akhi2 if $atecken > 0 && $akhi2 > 7.78; # spara om khi2 är tillräckligt stor (p > .90) och om ordet är vanligare än förväntat
# null assass --      }
# null assass --  }
# null assass --  # nu har sparat vi i %akhi2
# null assass --  
# null assass --  
my %askew;
# här är de tjugo skevaste orden för varje association

#foreach my $assoc (keys %notable) {
#    foreach my $ord ( ( sort {$akhi2{$assoc}{$b} <=> $akhi2{$assoc}{$a}} keys %{$akhi2{$assoc}})[0..20]) {
#      	$askew{$assoc}{$ord}++;
#    }
#}
#=================================================================
foreach my $what (keys %tagglista) {
    print "$what -----------------------------------\n";
    foreach my $ord ( keys %{$skev{$what}}) {
	next if $taggcount{$what}{$ord} < $mincollfreq;
	next if $observation{$ord} < $minobsfreq;
#  	print "\t$ord\t$taggcount{$what}{$ord}\t$observation{$ord}\t$khi2{$what}{$ord}\n" if $ord;
  	print "$ord\t$khi2{$what}{$ord}\n" if $ord;
#	foreach my $assass ( keys %{$askew{$ord}} ) {
#	    print "\t\t$assass\n";
#	}
	my $bg = "";
# 	for $w ( ( sort {$lhs{$ord}{$b} <=> $lhs{$ord}{$a}} keys %{$lhs{$ord}})[0..3] )  {
# 	    $bg .= "\t\t$w $ord\n" if $w && $lhs{$ord}{$w} > $threshold;
#	}
#	print "\tbigrams: [\n".$bg."\t\t]\n" if $bg;
#	print "]\n";
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

