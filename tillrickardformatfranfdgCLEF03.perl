#!/usr/bin/perl
# Jussi Karlgren, SICS, maj 2003
# tar fdg-processade tt-filer och expanderar sammansättningar till 
# olika möjliga delar i dem för att göra gsdm-indexering mer komplett.
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
    split;                                        # bryt raden vid varje tab - det är ett ord per rad
    $lemma = $_[2];                               # tredje spalten har lemmat
    next if $lemma =~ m¤[0-9\&\+\/\\\$\%\(\)><\.\?!,:;\=]¤;
    next if $stop{$lemma};
    $lemma =~ s¤[\'\*\-]¤¤g;
    next if $lemma eq "";                         # ta bort tomma morfem
    $lemma  =~ tr/A-ZÅÄÖ/a-zåäö/;                 # stora bokstäver till små
    @bitar = split('#',$lemma);                   # bryt lemmat vid varje brädgård och lägg i @bitar
    if ($#bitar > 0) {                            # blev det några beståndsdelar i @bitar att jobba med?
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
	print "( " unless $indexrun;
	foreach $u (@resultat) {
	    print "$u ";
	};
	print " ) " unless $indexrun;
    } else {                                # det var ingen sammansättning
	print "$lemma ";                    # skriv ut den bara
    };
};

print "</documents>\n" if $indexrun;
