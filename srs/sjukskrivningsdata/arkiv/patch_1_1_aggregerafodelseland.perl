#==============================================================================================================================
# plockar ihop en mer aggregerad fodelselandskod
#==============================================================================================================================
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
print "n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	";
print "FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	"; 
print "\n";
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

while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    next unless $delfall[0] > 0;
    
    for ($step=0; $step <= 22; $step++) {
	print "$delfall[$step]\t";
    }
    $step = 23; # FODELSELAND_KOD
    if ($delfall[$step] eq "SE") {print "SE\t";} 
    elsif ($delfall[$step] eq "00") {print "00\t";} 
    elsif ($delfall[$step] eq "FI") {print "NN\t";} 
    elsif ($delfall[$step] eq "NO") {print "NN\t";} 
    elsif ($delfall[$step] eq "DK") {print "NN\t";} 
    elsif ($delfall[$step] eq "IS") {print "NN\t";} 
    elsif ($delfall[$step] eq "NN") {print "NN\t";}  # if this accidentally is run on previously processed data
    elsif ($delfall[$step] eq "FODELSELAND_KOD") {print "FODELSELAND_KOD\t";} 
    else {print "VV\t";}
    for ($step=24; $step <= 41; $step++) {
	print "$delfall[$step]\t";
    }
    print "\n";
}
