#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade tt-filer och expanderar sammans�ttningar till 
# olika m�jliga delar i dem f�r att g�ra gsdm-indexering mer komplett.
$indexrun = 1;

open(STOPLIST, "</hosts/krumelur/e2/clef/bin/stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

if ($indexrun) {
    print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
    print "<documents numdocs=\"1\">\n";
};
while (<>) {  
    if ($indexrun) {
	if (m=^<DOCID>(TT9495-(\d+)-(\d+))</DOCID>=) {
	    print "<document type=\"newsprint\" name=\"$1\" date=\"$2\">\n";
	};
	if (m-^</DOC>-) {
	    print "\n</document>\n";
	};
    } else {
	print "\n" if (m-^</DOC>-);                   # mata ut radbrytning vid dokumentsluttagg 
    };
    next if (m=^<=);                              # strunta i taggar
    split;                                        # bryt raden vid varje tab - det �r ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
    next if $stop{$lemma};
    $lemma =~ s�[\'\*\-]��g;
    next if $lemma eq "";                         # ta bort tomma morfem
    $lemma  =~ tr/A-Z���/a-z���/;                 # stora bokst�ver till sm�
    @bitar = split('#',$lemma);                   # bryt lemmat vid varje br�dg�rd och l�gg i @bitar
    if ($#bitar > 0) {                            # blev det n�gra best�ndsdelar i @bitar att jobba med?
	@resultat = ();
	@ackumulator = ();
	foreach $bit (@bitar) {                       # kolla varje bit i @bitar
	    $bit =~ s�[\#]��g;
	    next if $bit eq "";                         # ta bort tomma morfem
	    $bbit = $bit;                            #  kopiera bit.
# beh�vs ej nu!	    $bbit =~ s/\-//g;                          # ta bort bindestreck som ibland �r kvar och l�gg i bbit.
	    @mellanlager = ();
	    push @mellanlager, $bit;                  # spara biten of�r�ndrad 
	    push @resultat, $bbit;                    # l�gg bindestrecksrensad bit i resultat
	    foreach $ini (@ackumulator) {             # ta alla b�rjor hittills
		push @mellanlager, $ini.$bit;         # forts�tt med det vi har och spara f�rl�ngningarna
		push @resultat, $ini.$bbit;         # spara f�rl�ngningarna utan bindestreck i resultat
	    };
	    $sbit = $bit;                            # slutar bit p� s? kopiera 
	    $s = chop $sbit;                         # plocka bort sista tecknet.
	    if ($s eq "s") {                          # �r det tecknet ett s?
		push @resultat, $sbit;               # spara en s-l�s bit.
		foreach $ini (@ackumulator) {             # ta alla b�rjor hittills
		    push @resultat, $ini.$sbit;      # forts�tt med det vi har och spara f�rl�ngningarna
		};
	    };
	    @ackumulator = @mellanlager;               # sl�ng alla gamla b�rjor och spara nya 
	    
	};                                             # allt det h�r g�rs f�r varje rad
	print "( " unless $indexrun;
	foreach $u (@resultat) {
	    print "$u ";
	};
	print " ) " unless $indexrun;
    } else {                                # det var ingen sammans�ttning
	print "$lemma ";                    # skriv ut den bara
    };
};

print "</documents>\n" if $indexrun;
