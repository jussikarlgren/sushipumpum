my $alt = 1;
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	FORSAKRADTYP_KOD	DIAGNOS_KOD	FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	\n";
while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split;
    $lopnr = $delfall[0];
    next if $lopnr eq "lopnr";
    $dettadelfall = $lopnr.$delfall[5].$delfall[6]; # lopnrfråndatum-tilldatum delfall
    $dettadelfall =~ s/\-//g;
    if ($seen{$dettadelfall}) {next;} else {$seen{$dettadelfall}++;}
    $index = $delfall[0].$delfall[11];
    next if $fertig{$index};
    for ($step=15; $step <= $#delfall; $step++) {
	unless ($aggregator{$index}[$step]) {$aggregator{$index}[$step] = $delfall[$step]; $lastone{$index}[$step] = $delfall[$step];}
	if ($lastone{$index}[$step] ne $delfall[$step]) {$aggregator{$index}[$step] .= "/".$delfall[$step]; $lastone{$index}[$step] = $delfall[$step];}
    }
    $diagnos = $delfall[16];
    if (! exists $diagnos{$index}) {
	unless ($diagnosdatum{$index} && ($dettadelfall > $diagnosdatum{$index})) {
	    $diagnos{$index} = $diagnos; $diagnosdatum{$index} = $dettadelfall; 
	}
    }
    $kommun = $delfall[24];
    if (! exists $kommun{$index}) {
	$kommun{$index} = $kommun; $kommundatum{$index} = $dettadelfall;
    } else {
        if ($kommun{$index} ne $kommun && $dettadelfall < $kommundatum{$index}) {
	    $kommun{$index} = $kommun; $kommundatum{$index} = $dettadelfall;
	}
#	    print "switch $index: $kommun{$index} -> $kommun; $kommundatum{$index} -> $dettadelfall; \n";
    }


    $n000{$index} += $delfall[7] if $delfall[3] == 0;
    $n025{$index} += $delfall[7] if $delfall[3] == 0.25;
    $n050{$index} += $delfall[7] if $delfall[3] == 0.5;
    $n075{$index} += $delfall[7] if $delfall[3] == 0.75;
    $n100{$index} += $delfall[7] if $delfall[3] == 1;
    $nbrt{$index} += $delfall[7];
    $nnet{$index} += $delfall[9];
    $cash{$index} += $delfall[10];
#    print "$index\t$dettadelfall $delfall[14] $nbrt{$index} ----";
#    print "$delfall[3] $delfall[7] ----";

#    print "$lopnr\t$delfall[11]\t$delfall[13]\t0:$n000{$index}\t25:$n025{$index}\t50:$n050{$index}\t75:$n075{$index}\t100:$n100{$index}\tb:$nbrt{$index}\tn:$nnet{$index}\tc:$cash{$index}\n";


    if ($nbrt{$index} >= $delfall[14]) { 
	$fertig{$index}++; 
	$n000{$index}	 = 0 unless $n000{$index};
	$n025{$index}	 = 0 unless $n025{$index};
	$n050{$index}	 = 0 unless $n050{$index};
	$n075{$index}	 = 0 unless $n075{$index};
	$n100{$index}	 = 0 unless $n100{$index};
	
	print "$lopnr\t$delfall[11]\t$delfall[13]\t$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t";
	for $kk (15) {print "$delfall[$kk]\t";}
	print "$diagnos{$index}\t";
	delete $diagnos{$index};
	delete $diagnosdatum{$index};
	for $kk (17, 18, 19, 20, 21, 22, 23) {print "$delfall[$kk]\t";}
	print "$kommun{$index}\t";
	delete $kommun{$index};
	delete $kommundatum{$index};
	for $kk (25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41) {print "$delfall[$kk]\t";}
	print "\n";
	delete $n000{$index};
	delete $n025{$index};
	delete $n050{$index};
	delete $n075{$index};
	delete $n100{$index};
	delete $nbrt{$index};
	delete $nnet{$index};
	delete $cash{$index};
    }

# 8157 fallfromdatum:$11 fallfromkommun:$24(första) ndag0=sum($7)IF($3==0) ndag25=sum($7)IF($3==0.25) ndag50=sum($7)IF($3==0.50) ndag75=sum($7)IF($3==0.75) ndag100=sum($7)IF($3==1) ndagbrutto=sum($8)=$14?



 #   $dindex = $delfall[0].$delfall[11].$delfall[5];
 #   $lan = substr $delfall[24], 0, 2;
 #   if (    $lan{$index} && $lan{$index} ne $lan) {$flytt{$index}++;}#print "FLYTT! $index $lan{$index} -> $lan\n";}
 #   $lan{$index} = $lan;
#    if (    $lan{$dindex} && $lan{$dindex} ne $lan) {print "FLYTT! $dindex $lan{$dindex} -> $lan $delfall[5]\n";}
#    $lan{$dindex} = $lan;
#    $historia{$lopnr}{$diagnos}++ unless $diagnos eq "-00";
#    $diagnos{$index} = $diagnos{$index}." ".$diagnos;
#    $person{$lopnr}++ unless $diagnos eq "-00";

}
# foreach $l (sort keys %person) {
#     print "$l\t";
#     foreach $d ( keys %{$historia{$l}}) {
# 	print "$d ";
#     }
#     print "\n";
# }



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
