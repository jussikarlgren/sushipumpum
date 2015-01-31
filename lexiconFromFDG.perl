#!/usr/local/bin/perl

while (<>) {
    if (m-<TEXT>-) {
	$text = 1;   
	next;
    }
    if (m-</TEXT>-) {
	$text = 0;   
	next;
    }
    if (m-<LP>-) {
	$rubrik = 1;   
	next;
    }
    if (m-</LP>-) {
	$rubrik = 0;   
	next;
    }
    next unless ($text || $rubrik);
    split;
    $word = $_[1];
    next if $word eq "";
    next if $word =~ /^[,<\.]/;
    $lemma= $_[2];
    $mtags = $_[6];
    if ($mtags eq "ING") {$mtags = "V";}
    if ($mtags eq "<Rel>") {$mtags = "PRON";}
    if ($mtags eq "Card") {$mtags = "NUM";}
    print "$word	$lemma	$mtags\n";

#    if ($m[$p] =~ /\@/) {$p++;}
#    if ($m[$p] =~ /\%/) {$p++;}
#    $pos = $m[$p];
#    print "$word	$lemma	$pos $m[0]-$m[1]-$p\n";
}

exit(0);
