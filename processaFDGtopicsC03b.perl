#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade s�kfr�ge-filer och expanderar sammans�ttningar till 
# olika m�jliga delar i dem f�r att g�ra gsdm-indexering mer komplett.

$splittitle = 1;
$splitdesc = 1;


open(STOPLIST, "</hosts/krumelur/e2/clef/bin/stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;


while (<>) {                                      
    if (m-<p>-) {
	print "\n" ;                   # mata ut radbrytning vid nytt stycke
	$d = 0;
	next;
    };
    if (m-yyy-) {
	print "\t";                   # dummy faeltseparator
	$d = 1;
	next;
    };
    split /\t/;                                        # bryt raden vid varje tab - det �r ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m�[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]�;
    next if $stop{$lemma};
    $lemma  =~ tr/A-Z���/a-z���/;                 # stora bokst�ver till sm�
    $lemma =~ s�[\n\'\*\-]��g;
    next if $lemma eq "";                         # ta bort tomma morfem
    @bitar = split('#',$lemma);                   # bryt lemmat vid varje br�dg�rd och l�gg i @bitar

    if ((($d  && $splitdesc)                      # �r det i desc-f�ltet? ska vi spj�lka det?
	 ||                                       # ELLER
	 (!$d && $splittitle))                    # �r det i title-f�ltet? ska vi spj�lka det d�?
	&&                                        # OCH
	$#bitar > 0) {                            # blev det n�gra best�ndsdelar i @bitar att jobba med?
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
	foreach $u (@resultat) {
	    print "$u ";
	};

    } else {
	$lemma =~ s�[\#]��g;
    print "$lemma ";                    # skriv ut den bara
    };
};

