#!/usr/bin/perl
#-------------------------------------
while (<>) {
    split;
    $_[0] =~ /WSJ(9\d)(\d\d)(\d\d)-(\d\d\d\d)/;
    $genre = $_[1];
    $year = "19".$1;
    $month = $2;
    $day = $3;
    $filename = "/src/harvahammas/corpora/en/WSJ/WSJ-fdg/$year/$month/$day/$_[0].fdg.xml";
#    print "\n$_ $_[0] $filename\n";
    print "\n";
    open(DATAFILE,"$filename");
    while (<DATAFILE>) {
	if (m-<TEXT>-) {
	    $text = 1;   
	    next;
	}
	if (m-</TEXT>-) {
	    $text = 0;   
	    next;
	}
	if (m-<LP>-) {
	    $text = 1;   
	    next;
	}
	if (m-</LP>-) {
	    $text = 0;   
	    next;
	}
	if (m-<HL>-) {
	    $rubrik = 1;   
	    next;
	}
	if (m-</HL>-) {
	    $rubrik = 0;   
	    next;
	}
#	next unless ($text || $rubrik);
	next unless $text;
	split;
	$word = $_[1];
	next if $word =~ /^[,\.\":\?!]/;
	$lemma= $_[2];
	next if $lemma eq "";
	next if $lemma eq "--";
	if ($lemma eq "<s>") {$lemma = "S";}
	if ($lemma eq "<p>") {$lemma = "P";}
#	$mtags = $_[6];
#	if ($mtags eq "ING") {$mtags = "V";}
#	if ($mtags eq "<Rel>") {$mtags = "PRON";}
#	if ($mtags eq "Card") {$mtags = "NUM";}
#	$tf{"$word	$lemma	$mtags"}++;
	print "$lemma ";
    }
    close(DATAFILE);    
} # while <>
















