#==============================================================================================================================
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# matar ut en sjukskrivning per rad, med randvariabler plockade från det äldsta fallet. 
# 11 juni 2015
# jussi
#==============================================================================================================================
use DateTime;
use DateTime::Format::Strptime;
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
#==============================================================================================================================
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
print "n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	";
print "FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	"; 
print "\n";

while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    $lopnr = $delfall[0];
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
    $dettadelfall = $lopnr.$delfall[5].$delfall[6]; # lopnrfråndatum-tilldatum delfall
    $dettadelfallstartdatum = $delfall[5];
    if ($seen{$dettadelfall}) {next;} else {$seen{$dettadelfall}++;}
    $index = $lopnr.$delfall[11]; #lopnr - sjukskrivningsstart
    $start{$index} = $delfall[11];
    $stop{$index} = $delfall[13];
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
	if ((! $diagnosdatum{$index}) || ($dettadelfallstartdatum < $diagnosdatum{$index}) || (! $aggregator{$index}[$step])) {
	    $aggregator{$index}[$step] = $delfall[$step];
	    $diagnosdatum{$index} = $dettadelfallstartdatum; 
	    if ($step == 16) {    $diagnosanteckning{$index} = $delfall[$step];}
	}
    }
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
	print "$lopnr\t$start{$index}\t$stop{$index}\t";
	print "$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t";

	for ($step=15; $step <= 41; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
	print "\n";

	delete $aggregator{$index};
	delete $diagnosdatum{$index};
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
    }
}

exit();

#finns det rester kvar?
##-## 
for $index (keys %nbrt) {
 	$fertig{$index}++; 
	print "oklar $index\n";
}
