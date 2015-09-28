#==============================================================================================================================
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# varje fall utökas med sjukskrivningstatistik från de senaste två åren för 
# a) samma diagnos
# b) F-diagnoser
# c) M-diagnoser
# d) alla diagnoser öht
# samma för eventuell makemaka.
#==============================================================================================================================
use DateTime;
use DateTime::Format::Strptime;
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
my $sparser  = DateTime::Format::Strptime->new( pattern => '%Y%m%d' );
my $vecka    = DateTime::Duration->new( days => 7);
#==============================================================================================================================
open GIFT,"<make_maka.txt";
while (<GIFT>) {
my @v = split;
$gift{$v[0]} = $v[1];
$gift{$v[1]} = $v[0];
$makemakasjukstart{$v[0]} = $parser->parse_datetime($v[2]);
$makemakasjukstop{$v[0]} = $parser->parse_datetime($v[3]);
}
close GIFT;
#==============================================================================================================================
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
print "n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	";
print "n000_2y	n025_2y	n050_2y	n075_2y	n100_2y	nbrutto_2y	nnetto_2y	summa_utbetalt_2y	";
print "n000_hittills	n025_hittills	n050_hittills	n075_hittills	n100_hittills	nbrutto_hittills	nnetto_hittills	summa_utbetalt_hittills	";
print "samma_n000_2y	samma_n025_2y	samma_n050_2y	samma_n075_2y	samma_n100_2y	samma_nbrutto_2y	samma_nnetto_2y	samma_summa_utbetalt_2y	";
print "samma_n000_hittills	samma_n025_hittills	samma_n050_hittills	samma_n075_hittills	samma_n100_hittills	samma_nbrutto_hittills	samma_nnetto_hittills	samma_summa_utbetalt_hittills	";
print "F_n000_2y	F_n025_2y	F_n050_2y	F_n075_2y	F_n100_2y	F_nbrutto_2y	F_nnetto_2y	F_summa_utbetalt_2y	";
print "F_n000_hittills	F_n025_hittills	F_n050_hittills	F_n075_hittills	F_n100_hittills	F_nbrutto_hittills	F_nnetto_hittills	F_summa_utbetalt_hittills	";
print "M_n000_2y	M_n025_2y	M_n050_2y	M_n075_2y	M_n100_2y	M_nbrutto_2y	M_nnetto_2y	M_summa_utbetalt_2y	";
print "M_n000_hittills	M_n025_hittills	M_n050_hittills	M_n075_hittills	M_n100_hittills	M_nbrutto_hittills	M_nnetto_hittills	M_summa_utbetalt_hittills	";
print "hemma_med_barn_intill_en_vecka_innan	";
print "FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	"; 
print "makemaka_sjuk_just_nu	";
print "makemaka_000_2y	makemaka_025_2y	makemaka_050_2y	makemaka_075_2y	makemaka_100_2y	makemaka_brutto_2y	makemaka_netto_2y	makemaka_summa_utbetalt_2y	";
print "makemaka_000_hittills	makemaka_025_hittills	makemaka_050_hittills	makemaka_075_hittills	makemaka_100_hittills	makemaka_brutto_hittills	makemaka_netto_hittills	makemaka_summa_utbetalt_hittills	";
print "\n";
$n0002y = 0;
$n0252y = 0;
$n0502y = 0;
$n0752y = 0;
$n1002y = 0;
$nbrt2y = 0;
$nnet2y = 0;
$cash2y = 0;
$n000AL = 0;
$n025AL = 0;
$n050AL = 0;
$n075AL = 0;
$n100AL = 0;
$nbrtAL = 0;
$nnetAL = 0;
$cashAL = 0;

$makemaka = "ogift";
$msjuk = 0;
$m0002y = 0;
$m0252y = 0;
$m0502y = 0;
$m0752y = 0;
$m1002y = 0;
$mbrt2y = 0;
$mnet2y = 0;
$mcash2y = 0;
$m000AL = 0;
$m025AL = 0;
$m050AL = 0;
$m075AL = 0;
$m100AL = 0;
$mbrtAL = 0;
$mnetAL = 0;
$mcashAL = 0;

while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    $lopnr = $delfall[0];
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
    $dettadelfall = $lopnr.$delfall[5].$delfall[6]; # lopnrfråndatum-tilldatum delfall
    $dettadelfall =~ s/\-//g;
    if ($seen{$dettadelfall}) {next;} else {$seen{$dettadelfall}++;}
    $index = $delfall[0].$delfall[11];
    $start{$index} = $delfall[11];
    $stop{$index} = $delfall[13];
    $startliteral{$index} = $delfall[11];
    $stopliteral{$index} = $delfall[13];
    $start{$index} =~ s/\-//g;
    $stop{$index}  =~ s/\-//g;
    $lopnr{$index} = $lopnr;
    next if $fertig{$index};
#==============================================================================================================================
# 0	lopnr
# 1	DELFORMAN1_KOD
# 2	DELFORMAN2_KOD
# 3	OMFATTNING
# 4	DAGBELOPP
# 5	DEL_FROM_DATUM
# 6	DEL_TOM_DATUM
# 7	DEL_DAGAR_TOT
# 8	DEL_DAGAR_BRUTTO
# 9	DEL_DAGAR_NETTO
# 10	DEL_BELOPP_BRUTTO
# 11	FALL_FROM_DATUM
# 12	FALL_FROM_DATUM2
# 13	FALL_TOM_DATUM
# 14	FALL_DAGAR_TOT
# 15	FORSAKRADTYP_KOD
# 16	DIAGNOS_KOD
# 17	ar_sysselsatt
# 18	SYSS_STATUS_KOD
# 19	SNI_2007
# 20	CFAR_NR
# 21	KON_KOD
# 22	fodelsear
# 23	FODELSELAND_KOD
# 24	KOMMUN_KOD
# 25	fromdat_kommun
# 26	tomdat_kommun
# 27	ANTAL_HEMMA
# 28	fromdat_hemmafor
# 29	tomdat_hemmafor
# 30	ar_pgi
# 31	PGI
# 32	ar_sgi
# 33	belopp_sgi_ar
# 34	inktyp_kod_sgi_ar
# 35	fromdat_sgi
# 36	tomdat_sgi
# 37	belopp_sgi
# 38	inktyp_kod_sgi
# 39	SSYK3
# 40	ar_yrke
# 41	lopnr_make_maka
    for ($step=15; $step <= $#delfall; $step++) {
	if ((! $diagnosdatum{$index}) || ($dettadelfall < $diagnosdatum{$index}) || (! $aggregator{$index}[$step])) {
	    $aggregator{$index}[$step] = $delfall[$step];
	    $diagnosdatum{$index} = $dettadelfall; 
	    if ($step == 16) {    $diagnosanteckning{$index} = $delfall[$step];}
	}
    }
#	unless ($aggregator{$index}[$step]) {$aggregator{$index}[$step] = $delfall[$step]; $lastone{$index}[$step] = $delfall[$step];}
#	if ($lastone{$index}[$step] ne $delfall[$step]) {$aggregator{$index}[$step] .= "/".$delfall[$step]; $lastone{$index}[$step] = $delfall[$step];}
#    $diagnos = $delfall[16];
#    if (! exists $diagnos{$index}) {
#	unless ($diagnosdatum{$index} && ($dettadelfall > $diagnosdatum{$index})) {
#	    $diagnos{$index} = $diagnos; $diagnosdatum{$index} = $dettadelfall; 
#	}
#    }
#    $kommun = $delfall[24];
#    print if length $kommun > 4;
#    print "********* >$delfall[24]<\n"  if length $kommun > 4;
#    if (exists $kommun{$index}{$kommun}) {
#	if ($kommun{$index}{$kommun} > $dettadelfall) {$kommun{$index}{$kommun} = $dettadelfall;}
#    } else {
#	$kommun{$index}{$kommun} = $dettadelfall;
#    }

#==============================================================================================================================
# räkna ihop värden för detta fall från delfallets fält
    $n000{$index} += $delfall[7] if $delfall[3] == 0;
    $n025{$index} += $delfall[7] if $delfall[3] == 0.25;
    $n050{$index} += $delfall[7] if $delfall[3] == 0.5;
    $n075{$index} += $delfall[7] if $delfall[3] == 0.75;
    $n100{$index} += $delfall[7] if $delfall[3] == 1;
    $nbrt{$index} += $delfall[7];
    $nnet{$index} += $delfall[9];
    $cash{$index} += $delfall[10];
#==============================================================================================================================
# vi har hela fallet samlat nu, om våra aggregerade bruttodagar är lika med fältet i delfallet som ska innehålla bruttodagar
    if ($nbrt{$index} >= $delfall[14]) { 
	$fertig{$index}++; 
	$n000{$index}	 = 0 unless $n000{$index};
	$n025{$index}	 = 0 unless $n025{$index};
	$n050{$index}	 = 0 unless $n050{$index};
	$n075{$index}	 = 0 unless $n075{$index};
	$n100{$index}	 = 0 unless $n100{$index};
#==============================================================================================================================
	print "$lopnr\t$startliteral{$index}\t$stopliteral{$index}\t";
	print "$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t";
#==============================================================================================================================
# anamnes!
	for $fd1 (keys %{ $anamnes{$lopnr} }) {
	    $fd = $start{$fd1};
# ALLA FALL
#valj ut de senaste två åren ur anamnesen
	    $n0002y	+=  $anamnes{$lopnr}{$fd}[0] if $start{$index} - $fd < 20000;
	    $n0252y	+=  $anamnes{$lopnr}{$fd}[1] if $start{$index} - $fd < 20000;
	    $n0502y	+=  $anamnes{$lopnr}{$fd}[2] if $start{$index} - $fd < 20000;
	    $n0752y	+=  $anamnes{$lopnr}{$fd}[3] if $start{$index} - $fd < 20000;
	    $n1002y	+=  $anamnes{$lopnr}{$fd}[4] if $start{$index} - $fd < 20000;
	    $nbrt2y	+=  $anamnes{$lopnr}{$fd}[5] if $start{$index} - $fd < 20000;
	    $nnet2y	+=  $anamnes{$lopnr}{$fd}[6] if $start{$index} - $fd < 20000;
	    $cash2y	+=  $anamnes{$lopnr}{$fd}[7] if $start{$index} - $fd < 20000;
#summera hela anamnesen	
	    $n000AL	+=  $anamnes{$lopnr}{$fd}[0];
	    $n025AL	+=  $anamnes{$lopnr}{$fd}[1];
	    $n050AL	+=  $anamnes{$lopnr}{$fd}[2];
	    $n075AL	+=  $anamnes{$lopnr}{$fd}[3];
	    $n100AL	+=  $anamnes{$lopnr}{$fd}[4];
	    $nbrtAL	+=  $anamnes{$lopnr}{$fd}[5];
	    $nnetAL	+=  $anamnes{$lopnr}{$fd}[6];
	    $cashAL	+=  $anamnes{$lopnr}{$fd}[7];
	}
	print "$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
	$n0002y = 0;
	$n0252y = 0;
	$n0502y = 0;
	$n0752y = 0;
	$n1002y = 0;
	$nbrt2y = 0;
	$nnet2y = 0;
	$cash2y = 0;
	$n000AL = 0;
	$n025AL = 0;
	$n050AL = 0;
	$n075AL = 0;
	$n100AL = 0;
	$nbrtAL = 0;
	$nnetAL = 0;
	$cashAL = 0;
    
	for $fd1 (keys %{ $anamnes{$lopnr} }) {
	    next unless $diagnosanteckning{$fd1} eq $diagnosanteckning{$index};
	    $fd = $start{$fd1};
# SAMMA DIAGNOS
#valj ut de senaste två åren ur anamnesen
	    $n0002y	+=  $anamnes{$lopnr}{$fd}[0] if $start{$index} - $fd < 20000;
	    $n0252y	+=  $anamnes{$lopnr}{$fd}[1] if $start{$index} - $fd < 20000;
	    $n0502y	+=  $anamnes{$lopnr}{$fd}[2] if $start{$index} - $fd < 20000;
	    $n0752y	+=  $anamnes{$lopnr}{$fd}[3] if $start{$index} - $fd < 20000;
	    $n1002y	+=  $anamnes{$lopnr}{$fd}[4] if $start{$index} - $fd < 20000;
	    $nbrt2y	+=  $anamnes{$lopnr}{$fd}[5] if $start{$index} - $fd < 20000;
	    $nnet2y	+=  $anamnes{$lopnr}{$fd}[6] if $start{$index} - $fd < 20000;
	    $cash2y	+=  $anamnes{$lopnr}{$fd}[7] if $start{$index} - $fd < 20000;
#summera hela anamnesen	
	    $n000AL	+=  $anamnes{$lopnr}{$fd}[0];
	    $n025AL	+=  $anamnes{$lopnr}{$fd}[1];
	    $n050AL	+=  $anamnes{$lopnr}{$fd}[2];
	    $n075AL	+=  $anamnes{$lopnr}{$fd}[3];
	    $n100AL	+=  $anamnes{$lopnr}{$fd}[4];
	    $nbrtAL	+=  $anamnes{$lopnr}{$fd}[5];
	    $nnetAL	+=  $anamnes{$lopnr}{$fd}[6];
	    $cashAL	+=  $anamnes{$lopnr}{$fd}[7];
	}
	print "$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
	$n0002y = 0;
	$n0252y = 0;
	$n0502y = 0;
	$n0752y = 0;
	$n1002y = 0;
	$nbrt2y = 0;
	$nnet2y = 0;
	$cash2y = 0;
	$n000AL = 0;
	$n025AL = 0;
	$n050AL = 0;
	$n075AL = 0;
	$n100AL = 0;
	$nbrtAL = 0;
	$nnetAL = 0;
	$cashAL = 0;

	for $fd1 (keys %{ $anamnes{$lopnr} }) {
	    next unless $diagnosanteckning{$fd1} =~ /^F/;
	    $fd = $start{$fd1};
# FDIAGNOSER
#valj ut de senaste två åren ur anamnesen
	    $n0002y	+=  $anamnes{$lopnr}{$fd}[0] if $start{$index} - $fd < 20000;
	    $n0252y	+=  $anamnes{$lopnr}{$fd}[1] if $start{$index} - $fd < 20000;
	    $n0502y	+=  $anamnes{$lopnr}{$fd}[2] if $start{$index} - $fd < 20000;
	    $n0752y	+=  $anamnes{$lopnr}{$fd}[3] if $start{$index} - $fd < 20000;
	    $n1002y	+=  $anamnes{$lopnr}{$fd}[4] if $start{$index} - $fd < 20000;
	    $nbrt2y	+=  $anamnes{$lopnr}{$fd}[5] if $start{$index} - $fd < 20000;
	    $nnet2y	+=  $anamnes{$lopnr}{$fd}[6] if $start{$index} - $fd < 20000;
	    $cash2y	+=  $anamnes{$lopnr}{$fd}[7] if $start{$index} - $fd < 20000;
#summera hela anamnesen	
	    $n000AL	+=  $anamnes{$lopnr}{$fd}[0];
	    $n025AL	+=  $anamnes{$lopnr}{$fd}[1];
	    $n050AL	+=  $anamnes{$lopnr}{$fd}[2];
	    $n075AL	+=  $anamnes{$lopnr}{$fd}[3];
	    $n100AL	+=  $anamnes{$lopnr}{$fd}[4];
	    $nbrtAL	+=  $anamnes{$lopnr}{$fd}[5];
	    $nnetAL	+=  $anamnes{$lopnr}{$fd}[6];
	    $cashAL	+=  $anamnes{$lopnr}{$fd}[7];
	}
	print "$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
	$n0002y = 0;
	$n0252y = 0;
	$n0502y = 0;
	$n0752y = 0;
	$n1002y = 0;
	$nbrt2y = 0;
	$nnet2y = 0;
	$cash2y = 0;
	$n000AL = 0;
	$n025AL = 0;
	$n050AL = 0;
	$n075AL = 0;
	$n100AL = 0;
	$nbrtAL = 0;
	$nnetAL = 0;
	$cashAL = 0;
   
	for $fd1 (keys %{ $anamnes{$lopnr} }) {
	    next unless $diagnosanteckning{$fd1} =~ /^M/;
	    $fd = $start{$fd1};
# MDIAGNOSER
#valj ut de senaste två åren ur anamnesen
	    $n0002y	+=  $anamnes{$lopnr}{$fd1}[0] if $start{$index} - $fd < 20000;
	    $n0252y	+=  $anamnes{$lopnr}{$fd1}[1] if $start{$index} - $fd < 20000;
	    $n0502y	+=  $anamnes{$lopnr}{$fd1}[2] if $start{$index} - $fd < 20000;
	    $n0752y	+=  $anamnes{$lopnr}{$fd1}[3] if $start{$index} - $fd < 20000;
	    $n1002y	+=  $anamnes{$lopnr}{$fd1}[4] if $start{$index} - $fd < 20000;
	    $nbrt2y	+=  $anamnes{$lopnr}{$fd1}[5] if $start{$index} - $fd < 20000;
	    $nnet2y	+=  $anamnes{$lopnr}{$fd1}[6] if $start{$index} - $fd < 20000;
	    $cash2y	+=  $anamnes{$lopnr}{$fd1}[7] if $start{$index} - $fd < 20000;
#summera hela anamnesen	
	    $n000AL	+=  $anamnes{$lopnr}{$fd1}[0];
	    $n025AL	+=  $anamnes{$lopnr}{$fd1}[1];
	    $n050AL	+=  $anamnes{$lopnr}{$fd1}[2];
	    $n075AL	+=  $anamnes{$lopnr}{$fd1}[3];
	    $n100AL	+=  $anamnes{$lopnr}{$fd1}[4];
	    $nbrtAL	+=  $anamnes{$lopnr}{$fd1}[5];
	    $nnetAL	+=  $anamnes{$lopnr}{$fd1}[6];
	    $cashAL	+=  $anamnes{$lopnr}{$fd1}[7];
	}
	print "$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
	$n0002y = 0;
	$n0252y = 0;
	$n0502y = 0;
	$n0752y = 0;
	$n1002y = 0;
	$nbrt2y = 0;
	$nnet2y = 0;
	$cash2y = 0;
	$n000AL = 0;
	$n025AL = 0;
	$n050AL = 0;
	$n075AL = 0;
	$n100AL = 0;
	$nbrtAL = 0;
	$nnetAL = 0;
	$cashAL = 0;

# uppdatera anamnesen
# lägg in i anamnes{lopnr}{start{index} en vektor med värden för detta fall
	@{ $anamnes{$lopnr}{$index} } = ($n000{$index}, $n025{$index}, $n050{$index}, $n075{$index},$n100{$index},$nbrt{$index},$nnet{$index},$cash{$index});
	push @{ $insjukna{$lopnr} }, $index;

#======================================================================================================================
# hemma med barn?
# slut på föräldraledighet:	
	my $fend = $parser->parse_datetime($aggregator{$index}[29]);
	my $frtid = $parser->parse_datetime($startliteral{$index});
	
	if ($fend + $vecka > $frtid) {
	    print "yes\t"; 
	} else {
	    print "no\t";
	}


	for ($step=15; $step < 41; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}

#makemaka
	if ($aggregator{$index}[41]) {
	    $makemaka = $aggregator{$index}[41];
	    for $fd1 (keys %{ $anamnes{$makemaka} }) {
		$fd = $start{$fd1};
#valj ut de senaste två åren ur anamnesen
	    $m0002y	+=  $anamnes{$makemaka}{$fd}[0] if $start{$index} - $fd < 20000;
	    $m0252y	+=  $anamnes{$makemaka}{$fd}[1] if $start{$index} - $fd < 20000;
	    $m0502y	+=  $anamnes{$makemaka}{$fd}[2] if $start{$index} - $fd < 20000;
	    $m0752y	+=  $anamnes{$makemaka}{$fd}[3] if $start{$index} - $fd < 20000;
	    $m1002y	+=  $anamnes{$makemaka}{$fd}[4] if $start{$index} - $fd < 20000;
	    $mbrt2y	+=  $anamnes{$makemaka}{$fd}[5] if $start{$index} - $fd < 20000;
	    $mnet2y	+=  $anamnes{$makemaka}{$fd}[6] if $start{$index} - $fd < 20000;
	    $mcash2y	+=  $anamnes{$makemaka}{$fd}[7] if $start{$index} - $fd < 20000;
#summera hela anamnesen	
	    $mn000AL	+=  $anamnes{$makemaka}{$fd}[0];
	    $mn025AL	+=  $anamnes{$makemaka}{$fd}[1];
	    $mn050AL	+=  $anamnes{$makemaka}{$fd}[2];
	    $mn075AL	+=  $anamnes{$makemaka}{$fd}[3];
	    $mn100AL	+=  $anamnes{$makemaka}{$fd}[4];
	    $mnbrtAL	+=  $anamnes{$makemaka}{$fd}[5];
	    $mnnetAL	+=  $anamnes{$makemaka}{$fd}[6];
	    $mcashAL	+=  $anamnes{$makemaka}{$fd}[7];
	}
	    for my $ill (keys @{ $insjukna{$makemaka} }) {
		if ($start{$ill} < $start{$index} && $stop{$ill} > $start{$index}) {$msjuk = 1;}
	    }
	}
	print "$makemaka\t$msjuk\t$m0002y\t$m0252y\t$m0502y\t$m0752y\t$m1002y\t$mbrt2y\t$mnet2y\t$mcash2y\t$m000AL\t$m025AL\t$m050AL\t$m075AL\t$m100AL\t$mbrtAL\t$mnetAL\t$mcashAL\t";
	$makemaka = "ogift";
	$msjuk = 0;
	$m0002y = 0;
	$m0252y = 0;
	$m0502y = 0;
	$m0752y = 0;
	$m1002y = 0;
	$mbrt2y = 0;
	$mnet2y = 0;
	$mcash2y = 0;
	$m000AL = 0;
	$m025AL = 0;
	$m050AL = 0;
	$m075AL = 0;
	$m100AL = 0;
	$mbrtAL = 0;
	$mnetAL = 0;
	$mcashAL = 0;

	print "\n";
	delete $aggregator{$index};
#  #  	for $kk (15) {print "$delfall[$kk]\t";}
#  #  	print "$diagnos{$index}\t";
#  #  	delete $diagnos{$index};
#  #  	delete $diagnosdatum{$index};
#  #  	for $kk (17, 18, 19, 20, 21, 22, 23) {print "$delfall[$kk]\t";}
#  #  	@kommuner = keys %{ $kommun{$index} };
#  #  #	if (scalar @kommuner > 1) {
#  #  #	    for $kd (sort { $kommun{$index}{$a} <=> $kommun{$index}{$b} } @kommuner ) {
#  #  #		print "$kd/";
#  #  #	    }
#  #  #	} else {
#  #  	    print "$kommuner[0]";
#  #  #	}
#  #  	print "\t";
#  #  	delete $kommun{$index};
#  #  	for $kk (25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41) {print "$delfall[$kk]\t";}
#  #  	print "\n";
	delete $n000{$index};
	delete $n025{$index};
	delete $n050{$index};
	delete $n075{$index};
	delete $n100{$index};
	delete $nbrt{$index};
	delete $nnet{$index};
	delete $cash{$index};
#	delete $lopnr{$index};
#	delete $start{$index};
#	delete $stop{$index};
	delete $startliteral{$index};
	delete $stopliteral{$index};
    }
}

exit();
#finns det rester kvar?
##-## 
for $index (keys %nbrt) {
 	$fertig{$index}++; 
	print "oklar $index\n";
}
##-## 	$n000{$index}	 = 0 unless $n000{$index};
##-## 	$n025{$index}	 = 0 unless $n025{$index};
##-## 	$n050{$index}	 = 0 unless $n050{$index};
##-## 	$n075{$index}	 = 0 unless $n075{$index};
##-## 	$n100{$index}	 = 0 unless $n100{$index};
##-## 
##-## #uppdatera anamnesen
##-## # lägg in i anamnes{lopnr}{start{index} en vektor med värden
##-## 	for $fd (keys %{ $anamnes{$lopnr} }) {
##-## #valj ut de senaste två åren ur anamnesen
##-## 	    $n0002y	+=  $anamnes{$lopnr}{$fd}[0] if $start{$index} - $fd < 20000;
##-## 	    $n0252y	+=  $anamnes{$lopnr}{$fd}[1] if $start{$index} - $fd < 20000;
##-## 	    $n0502y	+=  $anamnes{$lopnr}{$fd}[2] if $start{$index} - $fd < 20000;
##-## 	    $n0752y	+=  $anamnes{$lopnr}{$fd}[3] if $start{$index} - $fd < 20000;
##-## 	    $n1002y	+=  $anamnes{$lopnr}{$fd}[4] if $start{$index} - $fd < 20000;
##-## 	    $nbrt2y	+=  $anamnes{$lopnr}{$fd}[5] if $start{$index} - $fd < 20000;
##-## 	    $nnet2y	+=  $anamnes{$lopnr}{$fd}[6] if $start{$index} - $fd < 20000;
##-## 	    $cash2y	+=  $anamnes{$lopnr}{$fd}[7] if $start{$index} - $fd < 20000;
##-## #summera hela anamnesen	
##-## 	    $n000AL	+=  $anamnes{$lopnr}{$fd}[0];
##-## 	    $n025AL	+=  $anamnes{$lopnr}{$fd}[1];
##-## 	    $n050AL	+=  $anamnes{$lopnr}{$fd}[2];
##-## 	    $n075AL	+=  $anamnes{$lopnr}{$fd}[3];
##-## 	    $n100AL	+=  $anamnes{$lopnr}{$fd}[4];
##-## 	    $nbrtAL	+=  $anamnes{$lopnr}{$fd}[5];
##-## 	    $nnetAL	+=  $anamnes{$lopnr}{$fd}[6];
##-## 	    $cashAL	+=  $anamnes{$lopnr}{$fd}[7];
##-## 	}
##-## 	$anamnes{$lopnr}{$start{$index}} = ($n000{$index}, $n025{$index}, $n050{$index}, $n075{$index},$n100{$index},$nbrt{$index},$nnet{$index},$cash{$index});
##-## 
##-## 	print "$lopnr*\t$start{$index}\t$stop{$index}\t$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
##-## 	$n0002y = 0;
##-## 	$n0252y = 0;
##-## 	$n0502y = 0;
##-## 	$n0752y = 0;
##-## 	$n1002y = 0;
##-## 	$nbrt2y = 0;
##-## 	$nnet2y = 0;
##-## 	$cash2y = 0;
##-## 	$n000AL = 0;
##-## 	$n025AL = 0;
##-## 	$n050AL = 0;
##-## 	$n075AL = 0;
##-## 	$n100AL = 0;
##-## 	$nbrtAL = 0;
##-## 	$nnetAL = 0;
##-## 	$cashAL = 0;
##-## 
##-## 	for ($step=15; $step <= 41; $step++) {
##-## 	    print "$aggregator{$index}[$step]\t";
##-## 	}
##-## 	print "\n";
##-## 	delete $aggregator{$index};
##-## 
##-## 
##-## 	delete $n000{$index};
##-## 	delete $n025{$index};
##-## 	delete $n050{$index};
##-## 	delete $n075{$index};
##-## 	delete $n100{$index};
##-## 	delete $nbrt{$index};
##-## 	delete $nnet{$index};
##-## 	delete $cash{$index};
##-## 	delete $lopnr{$index};
##-## 	delete $start{$index};
##-## 	delete $stop{$index};
##-## 
##-## 
##-## 
##-## 
##-## 
##-## }



# 8157 fallfromdatum:$11 fallfromkommun:$24(första) ndag0=sum($7)IF($3==0) ndag25=sum($7)IF($3==0.25) ndag50=sum($7)IF($3==0.50) ndag75=sum($7)IF($3==0.75) ndag100=sum($7)IF($3==1) ndagbrutto=sum($8)=$14?


 #   $dindex = $delfall[0].$delfall[11].$delfall[5];
 #   $lan = substr $delfall[24], 0, 2;
 #   if (    $lan{$index} && $lan{$index} ne $lan) {$flytt{$index}++;}#print STDERR  "FLYTT! $index $lan{$index} -> $lan\n";}
 #   $lan{$index} = $lan;
#    if (    $lan{$dindex} && $lan{$dindex} ne $lan) {print STDERR  "FLYTT! $dindex $lan{$dindex} -> $lan $delfall[5]\n";}
#    $lan{$dindex} = $lan;
#    $historia{$lopnr}{$diagnos}++ unless $diagnos eq "-00";
#    $diagnos{$index} = $diagnos{$index}." ".$diagnos;
#    $person{$lopnr}++ unless $diagnos eq "-00";
# foreach $l (sort keys %person) {
#     print STDERR  "$l\t";
#     foreach $d ( keys %{$historia{$l}}) {
# 	print STDERR  "$d ";
#     }
#     print STDERR  "\n";
# }




#sub ddiff
