#!/usr/bin/perl
print $ARGV;


open(STOPLIST, "<stoplist.it");  
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
    if (/<DOCNO=([A-Z\d\.-]+)>/) {
	$name = $1;
$location = $ARGV;
if ($location =~ /(94\d\d\d\d)/) { $date = $1; } else { $date = 700101;};
	print "<document type=\"newsprint\" name=\"$name\" date=\"$date\" location=\"$location\">\n";
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
    split;
    next if $stop{$_[1]};
    $_[1] =~ s/\& /\&amp\; /;
    $_[1] =~ s/<\ //;
    $_[1] =~ s/\ >//;
    print "$_[1] ";
};

print "</documents>\n";


