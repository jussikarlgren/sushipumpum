#!/usr/bin/perl

open(STOPLIST, "<stoplist.fr");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

$docAntal = 0;

print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print "<documents numdocs=\"1\">\n";

while(<>) {
    chop;
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
    if (/(LEMONDE[\d-]+)\s/) {$docno = $1; $location = $ARGV; $date = substr($docno,17,6);};
    if (/^(9\d{5,5}\.\d{4,4})\s/) {$docno = "ATS.$1"; $location = $ARGV; $date = substr($1,0,6);};
    if (/\<\/DOCNO\>/) {
	print "<document type=\"newsprint\" name=\"$docno\" date=\"$date\" location=\"$location\">\n";
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
    s/\& /\&amp\; /;
    split;
    next if $stop{$_[1]};
    print "$_[1] ";
};

print "</documents>\n";


