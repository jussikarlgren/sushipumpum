#!/usr/bin/perl
# räknar ut vilka ord som är bäst att ha med i sökfrågan för svenska i clef2004
# jussi 12 maj 2004

open(STOPLIST, "<stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

open(Q,"sv.clean");
while (<Q>) {
    if (/c(\d\d\d)/) {$qno = $1; $c = 0;next;};
    if (/<p>/) {
	$c++; 
	split; 
	shift @_; 
	foreach $w (@_) {
	    next if $stop{$w};
	    @bitar = split('#',$w);                     # bryt lemmat vid varje brädgård och lägg i @bitar
	    if ($#bitar > 0) {                          # blev det några beståndsdelar i @bitar att jobba med?
		@resultat = ();
		@ackumulator = ();
		foreach $bit (@bitar) {                 # kolla varje bit i @bitar
		    $bit =~ s¤[\#]¤¤g;  
		    next if $bit eq "";                 # ta bort tomma morfem
		    @mellanlager = ();
		    push @mellanlager, $bit;            # spara biten oförändrad 
		    push @resultat, $bit;               # lägg biten i resultat
		    foreach $ini (@ackumulator) {       # ta alla börjor hittills
			push @mellanlager, $ini.$bit;   # fortsätt med det vi har och spara förlängningarna
			push @resultat, $ini.$bit;      # spara förlängningarna i resultat
						};
		    @ackumulator = @mellanlager;        # släng alla gamla börjor och spara nya 
				      };                # allt det här görs för varje rad
		foreach $u (@resultat) {
		    next if $stop{$u};
		    $wds{$u}++;
		};
			     } else {                   # det var inge nsammansättning
				 $wds{$w}++;
				    };
	};	  
    };
}
close(Q);
#foreach (sort keys %wds) {print; print "\n";};
while (<>) {
    chop;
    next if $_ eq "";
    next unless /\w+\t\w+/;
    split("	");
#1	TT9495-940101-139984	tt9495-940101-139984	main>0	@NH         Heur N UTR SG NOM
	$tag = $_[4];
    if ($_[1] =~ /(TT9495-\d+-\d+)/)  {
	if ($_[1] eq $docno) {next;};
 	if (@dok < 1)  {next;};
	$docno= $_[1];
	%this = ();
	foreach $c (@dok) {
	    $df{$c}++ unless $this{$c};
	    $this{$c}++;
	    $tf{$c}++;
	};
	foreach $c (@dok) {
	    if ($this{$c} > 1) {$nT{$c}++;};
	    if ($this{$c} == 1) {$n1{$c}++;};
	};
	foreach $k (keys %this) {
	    foreach $l (keys %this) {
		$cooccurs{$k}{$l}++;
#		print "$k $l 		$cooccurs{$k}{$l}\n";
	    }	    
	};
	$N++;
	@dok = ();
	next;
    };
    $c = lc $_[2];
    if ($tag =~ /(\+\w+)/) {$nametag{$c} = $1;};
    @bitar = split('#',$c);                   # bryt lemmat vid varje brädgård och lägg i @bitar
	if ($#bitar > 0) {                            # blev det några beståndsdelar i @bitar att jobba med?
	    @resultat = ();
	    @ackumulator = ();
	    foreach $bit (@bitar) {                       # kolla varje bit i @bitar
		$bit =~ s¤[\#]¤¤g;  
		next if $bit eq "";                         # ta bort tomma morfem
		@mellanlager = ();
		push @mellanlager, $bit;                  # spara biten oförändrad 
		push @resultat, $bit;                    # lägg biten i resultat
		foreach $ini (@ackumulator) {             # ta alla börjor hittills
		    push @mellanlager, $ini.$bit;         # fortsätt med det vi har och spara förlängningarna
		    push @resultat, $ini.$bit;         # spara förlängningarna i resultat
		};
		@ackumulator = @mellanlager;               # släng alla gamla börjor och spara nya 
	    };                                             # allt det här görs för varje rad
	    foreach $u (@resultat) {
		next unless $wds{$u};
		push @dok, $u;
	    };
	} else { # det var inge nsammansättning
	    next unless $wds{$c};
	    push @dok, $c;
	};
}
foreach (sort keys %df) {
    if ($N > 0) {
	$alpha=($nT{$_}+$n1{$_})/$N;
    } else {
	$alpha=1;
    };
    if ($nT{$_}+$n1{$_} > 0) { # borde inte behövas!
	$gamma=1-$n1{$_}/($nT{$_}+$n1{$_});
    } else {
	$gamma=1;
    };
    if ($nT{$_} > 0) {
	$Burst=($tf{$_}-$n1{$_})/$nT{$_};
    } else {
	$Burst = 0;
    };
    print "$_	$alpha	$gamma	$Burst	$nametag{$_}\n";
};

print "-----------\n";
foreach $c (sort keys %cooccurs) {
    print "$c:	";
    foreach $d (sort keys %{ $cooccurs{$c}}) {
	print "$cooccurs{$c}{$d}	";
    };
    print "\n";
};
