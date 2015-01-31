#!/usr/bin/perl


$docAntal = 0;

open(STOPLIST, "</src/harvahammas/corpora/fr/stoplist.fr");  
while (<STOPLIST>) {
    chop;
    $stop{$_} = 1;  
}
close STOPLIST;

$docAntal = 0;

while(<>) {
    if (/\<\/TEXT\>/) {
	$state = "eoftext";
	next;
    };
    if (/\<\/TX\>/) {
	$state = "eoftext";
	next;
    };
    if (/\<\/ST\>/) {
	$state = "eoftext";
	next;
    };
    if (/\<\/LD\>/) {
	$state = "eoftext";
	next;
    };
    if (/\<\/DOC\>/) {
	print "</section>\n" unless $state eq "notext";
	print "</document>\n";
	$state = "notext";
	next;
    };
    if (/<DOCNO>(LEMONDE[\d-]+)</) {$docno = $1; $location = $ARGV; $date = substr($docno,17,6); 	print "<document type=\"newsprint\" name=\"$docno\" date=\"$date\" location=\"$location\">\n";
};
    if (/<DOCNO>ATS.(9\d{5,5}\.\d{4,4})/) {$docno = "ATS.$1"; $location = $ARGV; $date = substr($1,0,6);
	print "<document type=\"newsprint\" name=\"$docno\" date=\"$date\" location=\"$location\">\n";
};
    if (/\<\/DOCNO\>/) {
	$docAntal++;
	next;
    };
    if (/\<LD\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
    };
    if (/\<ST\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
    };
    if (/\<TX\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
    };
    if (/\<TEXT\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
    };
    if (/\<TITLE\>/) {
	print "<section name=\"TITLE\">";
	$state = "text";
    };
    if (/\<TI\>/) {
	print "<section name=\"TITLE\">";
	$state = "text";
    };
    if (/\<\/TITLE\>/) {
	print "</section>\n";
	$state = "notext";
	next;
    };
    if (/\<\/TI\>/) {
	print "</section>\n";
	$state = "notext";
	next;
    };
    next unless $state eq "text";
    s/\& //g;
    split;
    next if $stop{$_[1]};
    print "$_[1] ";
};



