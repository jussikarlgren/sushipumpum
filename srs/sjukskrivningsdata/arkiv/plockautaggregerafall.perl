my $alt = 1;
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	n000_2y	n025_2y	n050_2y	n075_2y	n100_2y	nbrutto_2y	nnetto_2y	summa_utbetalt_2y	n000_hittills	n025_hittills	n050_hittills	n075_hittills	n100_hittills	nbrutto_hittills	nnetto_hittills	summa_utbetalt_hittills	FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	\n";
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
    $n000{$index} += $delfall[7] if $delfall[3] == 0;
    $n025{$index} += $delfall[7] if $delfall[3] == 0.25;
    $n050{$index} += $delfall[7] if $delfall[3] == 0.5;
    $n075{$index} += $delfall[7] if $delfall[3] == 0.75;
    $n100{$index} += $delfall[7] if $delfall[3] == 1;
    $nbrt{$index} += $delfall[7];
    $nnet{$index} += $delfall[9];
    $cash{$index} += $delfall[10];
#==============================================================================================================================
    if ($nbrt{$index} >= $delfall[14]) { 
	$fertig{$index}++; 
	$n000{$index}	 = 0 unless $n000{$index};
	$n025{$index}	 = 0 unless $n025{$index};
	$n050{$index}	 = 0 unless $n050{$index};
	$n075{$index}	 = 0 unless $n075{$index};
	$n100{$index}	 = 0 unless $n100{$index};

#uppdatera anamnesen
# lägg in i anamnes{lopnr}{start{index} en vektor med värden
	for $fd (keys %{ $anamnes{$lopnr} }) {
#	    print STDERR "$cash2y+$anamnes{$lopnr}{$fd}[7] && $cashAL+$anamnes{$lopnr}{$fd}[7]  -> ";
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
#	    print STDERR "$cash2y $cashAL $start{$index} - $fd = ";
#	    print STDERR $start{$index}-$fd;
#	    print STDERR "\n";
	}
	@{ $anamnes{$lopnr}{$start{$index}} } = ($n000{$index}, $n025{$index}, $n050{$index}, $n075{$index},$n100{$index},$nbrt{$index},$nnet{$index},$cash{$index});



	print "$lopnr\t$startliteral{$index}\t$stopliteral{$index}\t$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
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

	for ($step=15; $step <= 41; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
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
	delete $lopnr{$index};
	delete $start{$index};
	delete $stop{$index};
	delete $startliteral{$index};
	delete $stopliteral{$index};
    }
}

exit();
#finns det rester kvar?

for $index (keys %nbrt) {
	$fertig{$index}++; 
	$n000{$index}	 = 0 unless $n000{$index};
	$n025{$index}	 = 0 unless $n025{$index};
	$n050{$index}	 = 0 unless $n050{$index};
	$n075{$index}	 = 0 unless $n075{$index};
	$n100{$index}	 = 0 unless $n100{$index};

#uppdatera anamnesen
# lägg in i anamnes{lopnr}{start{index} en vektor med värden
	for $fd (keys %{ $anamnes{$lopnr} }) {
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
	$anamnes{$lopnr}{$start{$index}} = ($n000{$index}, $n025{$index}, $n050{$index}, $n075{$index},$n100{$index},$nbrt{$index},$nnet{$index},$cash{$index});

	print "$lopnr*\t$start{$index}\t$stop{$index}\t$n000{$index}\t$n025{$index}\t$n050{$index}\t$n075{$index}\t$n100{$index}\t$nbrt{$index}\t$nnet{$index}\t$cash{$index}\t$n0002y\t$n0252y\t$n0502y\t$n0752y\t$n1002y\t$nbrt2y\t$nnet2y\t$cash2y\t$n000AL\t$n025AL\t$n050AL\t$n075AL\t$n100AL\t$nbrtAL\t$nnetAL\t$cashAL\t";
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

	for ($step=15; $step <= 41; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
	print "\n";
	delete $aggregator{$index};


	delete $n000{$index};
	delete $n025{$index};
	delete $n050{$index};
	delete $n075{$index};
	delete $n100{$index};
	delete $nbrt{$index};
	delete $nnet{$index};
	delete $cash{$index};
	delete $lopnr{$index};
	delete $start{$index};
	delete $stop{$index};





}



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






















