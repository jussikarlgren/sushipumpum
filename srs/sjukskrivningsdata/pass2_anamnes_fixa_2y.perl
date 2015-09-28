# kör med *lopnr-sorterad* pass1-output som input!
#==============================================================================================================================
# 2.0
# fixar en wart som gjorde att M_*_2y etc har oväntade värden. 
# fixar så att "-00" inte är en diagnos som bidrar till "samma"
# disable nästan alla utom *_brutto_2y-variablerna tills vidare
# 
#
# 1.0
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# varje fall utökas med sjukskrivningstatistik från de senaste två åren för 
# a) samma diagnos
# b) F-diagnoser
# c) M-diagnoser
# d) alla diagnoser öht
#
#==============================================================================================================================
use DateTime;
use DateTime::Format::Strptime;
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
my $tvaaaar = DateTime::Duration->new( years => 2);
my $vecka    = DateTime::Duration->new( days => 7);
#==============================================================================================================================
# 0-2
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
# 3-10
print "n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	";
# 11-18
print "n000_2y	n025_2y	n050_2y	n075_2y	n100_2y	nbrutto_2y	nnetto_2y	summa_utbetalt_2y	";
# 19-26
print "n000_hittills	n025_hittills	n050_hittills	n075_hittills	n100_hittills	nbrutto_hittills	nnetto_hittills	summa_utbetalt_hittills	";
# 27-34
print "samma_n000_2y	samma_n025_2y	samma_n050_2y	samma_n075_2y	samma_n100_2y	samma_nbrutto_2y	samma_nnetto_2y	samma_summa_utbetalt_2y	";
# 33-42
print "samma_n000_hittills	samma_n025_hittills	samma_n050_hittills	samma_n075_hittills	samma_n100_hittills	samma_nbrutto_hittills	samma_nnetto_hittills	samma_summa_utbetalt_hittills	";
# 41-50
print "F_n000_2y	F_n025_2y	F_n050_2y	F_n075_2y	F_n100_2y	F_nbrutto_2y	F_nnetto_2y	F_summa_utbetalt_2y	";
# 49-58
print "F_n000_hittills	F_n025_hittills	F_n050_hittills	F_n075_hittills	F_n100_hittills	F_nbrutto_hittills	F_nnetto_hittills	F_summa_utbetalt_hittills	";
# 57-66
print "M_n000_2y	M_n025_2y	M_n050_2y	M_n075_2y	M_n100_2y	M_nbrutto_2y	M_nnetto_2y	M_summa_utbetalt_2y	";
# 65-74
print "M_n000_hittills	M_n025_hittills	M_n050_hittills	M_n075_hittills	M_n100_hittills	M_nbrutto_hittills	M_nnetto_hittills	M_summa_utbetalt_hittills	";
# 75
print "hemma_med_barn_intill_en_vecka_innan	";
# (13-39) -> 76-...
print "FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka";
print "\n";
#==============================================================================================================================
# 0	lopnr
# 1	FALL_FROM_DATUM
# 2	FALL_TOM_DATUM
# 3-10	n000
#       n025
#       n050
#       n075
#       n100
#       nbrt
#       nnet
#       cash
# 11	FORSAKRADTYP_KOD
# 12	DIAGNOS_KOD
# 13	ar_sysselsatt
# 14	SYSS_STATUS_KOD
# 15	SNI_2007
# 26	CFAR_NR
# 27	KON_KOD
# 28	fodelsear
# 29	FODELSELAND_KOD
# 20	KOMMUN_KOD
# 21	fromdat_kommun
# 22	tomdat_kommun
# 23	ANTAL_HEMMA
# 24	fromdat_hemmafor
# 25	tomdat_hemmafor
# 36	ar_pgi
# 37	PGI
# 38	ar_sgi
# 39	belopp_sgi_ar
# 30	inktyp_kod_sgi_ar
# 31	fromdat_sgi
# 32	tomdat_sgi
# 33	belopp_sgi
# 34	inktyp_kod_sgi
# 35	SSYK3
# 36	ar_yrke
# 37	lopnr_make_maka
#================================================
while (<>) {
    chop;
    next if length $_ < 1;
    @sjukskrivningsfall = split "\t";
    $prev = $lopnr;
    $lopnr = $sjukskrivningsfall[0];
#    if ($lopnr < $prev) {die "************************** indata måste vara sorterad!\n";}
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
    $dettasjukskrivningsfall = $lopnr.$sjukskrivningsfall[1].$sjukskrivningsfall[2]; # lopnrfråndatum-tilldatum sjukskrivningsfall
    $start{$index} = $sjukskrivningsfall[1];
    $stop{$index} = $sjukskrivningsfall[2];
    $lopnr{$index} = $lopnr;
    $diagnos = $sjukskrivningsfall[12];
#==============================================================================================================================
# räkna ut saker om anamnes bakåt i tiden!
# INIT
    for $per ("2y","hela") {
	for $kat ("alla","samma","F","M") {
	    for ($key=0;$key<8;$key++) {
		$nvektor{$per}{$kat}[$key] = 0;
	    }
	}
    }
#================================================
    my $tidpunkt = $parser->parse_datetime($start{$index});  # här är vi nu!
    my $tidpunktC = $parser->parse_datetime($start{$index});  # här är vi nu!
    my $bortreparentes = $tidpunktC->subtract_duration($tvaaaar);
    for $start (keys %{ $anamnes{$lopnr} }) { # tag alla kända fall med samma person (lopnr), de börjar i tur och ordning på "start"
	$slut = $anamnes{$lopnr}{$start}[1];  # ok - nu har vi hittat fall som börjar på start och slutar på slut
	my $sluttid = $parser->parse_datetime($slut); 
	my $begtid = $parser->parse_datetime($start); 
	my $tvaaefterslut = $sluttid->add($tvaaaar);
	my $tva = 0;
	my $overlapp = $anamnes{$lopnr}{$start}[7];
###	print "($anamnes{$lopnr}{$start}[10])\t";
	if  (DateTime->compare($tvaaefterslut,$tidpunkt) > 0) {# har fallet slutat mindre än två år sedan?
	    $tva = 1;
###	    print "<=2\t";
	    if  (DateTime->compare($bortreparentes,$begtid) > 0) {  # har fallet börjat mer än två år sedan?
		$overlapp = $overlapp - $bortreparentes->delta_days($begtid)->in_units( 'days' );
	    }
	}  else {
###	    print ">2\t";
	}
###	print "o:$overlapp\t";
#	for ($key=0;$key < 8;$key++) {             # 000 025 050 075 100 brutto netto cash 
###	for $kat ("alla","samma","F","M") {
###	    for $per ("2y","hela") {
###		for ($key=0;$key<8;$key++) {
###		    $tvektor{$per}{$kat}[$key] = $nvektor{$per}{$kat}[$key];
###		}
###	    }
###	}
	for ($key=0;$key < 8;$key++) { #	for ($key=5;$key < 6;$key++) {             # bara brutto
	    if ($tva && $key == 5) {
		$nvektor{"2y"}{"alla"}[$key]	+=  $overlapp;
	    }
	    $nvektor{"hela"}{"alla"}[$key]	+=  $anamnes{$lopnr}{$start}[$key+2];
	    if ($anamnes{$lopnr}{$start}[10] eq $diagnos && $diagnos ne "-00") {
		if ($tva && $key == 5) {
		    $nvektor{"2y"}{"samma"}[$key]	+=  $overlapp;
		}
		$nvektor{"hela"}{"samma"}[$key]	+=  $anamnes{$lopnr}{$start}[$key+2];
	    }
	    if ($anamnes{$lopnr}{$start}[10] =~ /^F/) {
		if ($tva && $key == 5) {
		    $nvektor{"2y"}{"F"}[$key]	+=  $overlapp;
		}
		$nvektor{"hela"}{"F"}[$key]	+=  $anamnes{$lopnr}{$start}[$key+2];
	    }
	    if ($anamnes{$lopnr}{$start}[10] =~ /^M/) {
		if ($tva && $key == 5) {
		    $nvektor{"2y"}{"M"}[$key]	+=  $overlapp;
		}
		$nvektor{"hela"}{"M"}[$key]	+=  $anamnes{$lopnr}{$start}[$key+2];
	    }
	}
###	for $per ("2y") { #for $per ("2y","hela") {
###	    for $kat ("alla","samma","F","M") {
###	    for ($key=6;$key<7;$key++) {
###		print "$diagnos:$anamnes{$lopnr}{$start}[10]:$per:$kat:$key:$tvektor{$per}{$kat}[$key]->$nvektor{$per}{$kat}[$key]\t";
###	    }
###	}
###    }
###    print "\n.....\n";
    }
    for ($key=0;$key<11;$key++) {
	print "$sjukskrivningsfall[$key]\t";
    }
    for $kat ("alla","samma","F","M") {
	for $per ("2y","hela") {
	    for ($key=0;$key<8;$key++) {
		print "$nvektor{$per}{$kat}[$key]\t";
	    }
	}
    }
#======================================================================================================================
# hemma med barn?
# slut på föräldraledighet:	
    my $fend = $parser->parse_datetime($sjukskrivningsfall[25]);
    if ($fend + $vecka > $tidpunkt) {
	print "yes\t"; 
   } else {
	print "no\t";
    }
    
#======================================================================================================================
    for ($step=11; $step <= 40; $step++) {
	print "$sjukskrivningsfall[$step]\t";
    }
    print "\n";
###    print "============================\n";
#==============================================================================================================================
    if ($prev ne $lopnr) { # ny individ
	%anamnes = (); #reset cache
    }
#==============================================================================================================================
# skapa grund för kommande anamnesberäkning!
# en vektor med start slut n000 n025 n050 n075 n100 nbrt nnet cash diagnos
    @{ $anamnes{$lopnr}{$start{$index} } } = ($start{$index}, $stop{$index} ,$sjukskrivningsfall[3],$sjukskrivningsfall[4],$sjukskrivningsfall[5], $sjukskrivningsfall[6], $sjukskrivningsfall[7], $sjukskrivningsfall[8],$sjukskrivningsfall[9],$sjukskrivningsfall[10],$diagnos);
}
exit();
