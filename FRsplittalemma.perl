#!/usr/bin/perl
open(FIL,">dummy.lemma");
select(FIL);
open(STOPLIST, "<stoplist.fr");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

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
	print "</section>\n";
	close(FIL);
	$state = "notext";
	next;
    };
#    if (m_<DOCNO>((ATS|LEMONDE)[\d-\.]+)</DOCNO>_) {
    if (/<DOCNO>/) {
	$_ =~ m/([ATSLEMONDE]+[\d-\.]+)/;
	$docno = "$1"; $location = $ARGV; $date = substr($1,0,6);
	open(FIL,">$docno.lemma");
	select(FIL);
	print FIL $_;
    }
    if (/\<LD\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
	next;
    };
    if (/\<ST\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
	next;
    };
    if (/\<TX\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
	next;
    };
    if (/\<TEXT\>/) {
	print "<section name=\"TEXT\">" if $state eq "notext";
	$state = "text";
	next;
    };
    if (/\<TITLE\>/) {
	print "<section name=\"TITLE\">";
	$state = "text";
	next;
    };
    if (/\<TI\>/) {
	print "<section name=\"TITLE\">";
	$state = "text";
	next;
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
    next if $stop{$_};
    print "$_ ";
};


