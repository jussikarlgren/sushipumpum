#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade sökfråge-filer och expanderar sammansättningar till 
# olika möjliga delar i dem för att göra gsdm-indexering mer komplett.

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
    split /\t/;                                        # bryt raden vid varje tab - det är ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
    next if $stop{$lemma};
    $lemma  =~ tr/A-ZÅÄÖ/a-zåäö/;                 # stora bokstäver till små
    $lemma =~ s¤[\n\'\*\-]¤¤g;
    next if $lemma eq "";                         # ta bort tomma morfem
    @bitar = split('#',$lemma);                   # bryt lemmat vid varje brädgård och lägg i @bitar

    if ((($d  && $splitdesc)                      # är det i desc-fältet? ska vi spjälka det?
	 ||                                       # ELLER
	 (!$d && $splittitle))                    # är det i title-fältet? ska vi spjälka det då?
	&&                                        # OCH
	$#bitar > 0) {                            # blev det några beståndsdelar i @bitar att jobba med?
	    @resultat = ();
	    @ackumulator = ();
	    foreach $bit (@bitar) {                       # kolla varje bit i @bitar
		$bit =~ s¤[\#]¤¤g;
		next if $bit eq "";                         # ta bort tomma morfem
		$bbit = $bit;                            #  kopiera bit.
# behövs ej nu!	    $bbit =~ s/\-//g;                          # ta bort bindestreck som ibland är kvar och lägg i bbit.
		@mellanlager = ();
		push @mellanlager, $bit;                  # spara biten oförändrad 
		push @resultat, $bbit;                    # lägg bindestrecksrensad bit i resultat
		foreach $ini (@ackumulator) {             # ta alla börjor hittills
		    push @mellanlager, $ini.$bit;         # fortsätt med det vi har och spara förlängningarna
		    push @resultat, $ini.$bbit;         # spara förlängningarna utan bindestreck i resultat
		};
		$sbit = $bit;                            # slutar bit på s? kopiera 
		$s = chop $sbit;                         # plocka bort sista tecknet.
		if ($s eq "s") {                          # är det tecknet ett s?
		    push @resultat, $sbit;               # spara en s-lös bit.
		    foreach $ini (@ackumulator) {             # ta alla börjor hittills
			push @resultat, $ini.$sbit;      # fortsätt med det vi har och spara förlängningarna
		    };
	    };
	    @ackumulator = @mellanlager;               # släng alla gamla börjor och spara nya 
	    
	};                                             # allt det här görs för varje rad
	foreach $u (@resultat) {
	    print "$u ";
	};

    } else {
	$lemma =~ s¤[\#]¤¤g;
    print "$lemma ";                    # skriv ut den bara
    };
};

