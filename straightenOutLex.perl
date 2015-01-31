#!/usr/bin/perl
$prev = "dummy";
$THRESHOLD=12;
while(<>) {
    split;
    $pos = $_[2];
    next if $pos eq "<?>"; # take out misprints
    $token = $_[0];
    next if ($token =~ /[\W]+/); # take out character nonsense
    $lemma = $_[1];
#    $score = $_[3];
    $token =~ tr/A-Z/a-z/;
    if ($token ne $prev) {
#	if ($df > $THRESHOLD) {
	print "$token	$lemma	$pos\n" ;
#	    }     
	$prev = $token;
#	$df = 0;
#    } else {
#	$df += $score;
    }
}

