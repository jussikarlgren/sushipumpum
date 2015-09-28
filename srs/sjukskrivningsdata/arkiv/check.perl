$kk = 23;
while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    $lopnr = $delfall[0];
    $dettadelfall = $lopnr.$delfall[5].$delfall[6]; # fråndatum-tilldatum delfall
    $index = $delfall[0].$delfall[11];
    $falt = $delfall[$kk];
    if (! exists $falt{$index}) {
	unless ($falt eq "-00") {$falt{$index} = $falt;}
    } else {
	if ($falt ne "-00" && $falt{$index} ne $falt) {print "kaos med $kk: $index $delfall $falt $falt{$index}\n";}
    }
}


#, 15	FORSAKRADTYP_KOD
#, 16	DIAGNOS_KOD
#, 17	ar_sysselsatt
#, 18	SYSS_STATUS_KOD
#, 19	SNI_2007
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
