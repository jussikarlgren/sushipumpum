#==============================================================================================================================
# 0-2
#print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
## 3-10
#print "n000	n025	n050	n075	n100	nbrutto	nnetto	summa_utbetalt	";
## 11-18
#print "n000_2y	n025_2y	n050_2y	n075_2y	n100_2y	nbrutto_2y	nnetto_2y	summa_utbetalt_2y	";
## 19-26
#print "n000_hittills	n025_hittills	n050_hittills	n075_hittills	n100_hittills	nbrutto_hittills	nnetto_hittills	summa_utbetalt_hittills	";
## 27-34
#print "samma_n000_2y	samma_n025_2y	samma_n050_2y	samma_n075_2y	samma_n100_2y	samma_nbrutto_2y	samma_nnetto_2y	samma_summa_utbetalt_2y	";
## 33-42
#print "samma_n000_hittills	samma_n025_hittills	samma_n050_hittills	samma_n075_hittills	samma_n100_hittills	samma_nbrutto_hittills	samma_nnetto_hittills	samma_summa_utbetalt_hittills	";
## 41-50
#print "F_n000_2y	F_n025_2y	F_n050_2y	F_n075_2y	F_n100_2y	F_nbrutto_2y	F_nnetto_2y	F_summa_utbetalt_2y	";
## 49-58
#print "F_n000_hittills	F_n025_hittills	F_n050_hittills	F_n075_hittills	F_n100_hittills	F_nbrutto_hittills	F_nnetto_hittills	F_summa_utbetalt_hittills	";
## 57-66
#print "M_n000_2y	M_n025_2y	M_n050_2y	M_n075_2y	M_n100_2y	M_nbrutto_2y	M_nnetto_2y	M_summa_utbetalt_2y	";
## 65-74
#print "M_n000_hittills	M_n025_hittills	M_n050_hittills	M_n075_hittills	M_n100_hittills	M_nbrutto_hittills	M_nnetto_hittills	M_summa_utbetalt_hittills	";
## 75
#print "hemma_med_barn_intill_en_vecka_innan	";
## (13-39) -> 76-...
#print "FORSAKRADTYP_KOD	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka";
#print "\n";


#open OLD, "</home/jussi/srs/testfall/5.p2v3.txt";
open OLD, "</home/jussi/srs/augustileverans/pass2_med_anamnes_v3.txt";
while (<OLD>) {
    @felt = split;
    $b{$felt[0].$felt[1]} = $felt[16];
    $s{$felt[0].$felt[1]} = $felt[32];
    $F{$felt[0].$felt[1]} = $felt[48];
    $M{$felt[0].$felt[1]} = $felt[64];
}
close OLD;
while (<>) {
    @felt = split;
    $key = $felt[0].$felt[1];
    for ($i = 0; $i < 103; $i++) {
   	if ($i == 16)    {print "($i:$felt[$i]->)"."$b{$key}\t";}
	elsif ($i == 16) {print "($i:$felt[$i]->)"."$s{$key}\t";}
	elsif ($i == 16) {print "($i:$felt[$i]->)"."$F{$key}\t";}
	elsif ($i == 16) {print "($i:$felt[$i]->)"."$M{$key}\t";}
	else {print "$felt[$i]\t";}
    }
    print "\n";
}
