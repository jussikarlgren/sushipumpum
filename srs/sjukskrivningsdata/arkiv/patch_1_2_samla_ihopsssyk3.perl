#==============================================================================================================================
# tar reda på ssyk3-koder för individer
# kör på huvudpersoner.txt
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

while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    next unless $delfall[0] > 0;
    $lopnr = $delfall[0];
    $index{$lopnr}++;
    $step = 39; # SSYK3
    $ssyk3 = $delfall[$step];
    next unless $ssyk3;
    $ssyk3{$lopnr}{$ssyk3}++;
}

for $lopnr (keys %index) {
    
    print "$lopnr\t";
    unless ($lopnr{$index}) {
	for $ssyk3 (sort { $ssyk3{$lopnr}{$b} <=>  $ssyk3{$lopnr}{$a} } keys %{ $ssyk3{$lopnr}  }) {
	    print "$ssyk3\t";
	}
    } else  {
	print "000";
    }
    print "\n";
}       
