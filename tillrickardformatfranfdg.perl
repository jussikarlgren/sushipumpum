#!/usr/bin/perl

open(STOPLIST, "<stoplist.sv");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;


print "<?xml version='1.0' encoding='iso-8859-1'?>\n";
print "<documents numdocs=\"1\">\n";
print "<document type=\"newsprint\" name=\"$ARGV\">\n";

while(<>) {
    chop;
    if (/\<\/BRODTEXT\>/) {
	print "</section>\n";
	$state = "notext";
    };
    if (/\<BRODTEXT\>/) {
	print "<section name=\"TEXT\">";
	$state = "text";
    };
    if (/\<INGRESS\>/) {
	print "<section name=\"INGRESS\">";
	$state = "text";
    };
    if (/\<RUBRIK\>/) {
	print "<section name=\"TITLE\">";
	$state = "text";
    };
    if (/\<\/RUBRIK\>/) {
	print "</section>\n";
	$state = "notext";
    };
    if (/\<\/INGRESS\>/) {
	print "</section>\n";
	$state = "notext";
    };
    split;
    if ($_[2] =~ /\<s\>/) {
#	print "\n";
    } elsif ($_[2] =~ /\<p\>/) {
#	print "\n";
    } elsif($state eq "text") {
	next if $stop{$_[2]};
	next if $_[3] eq "Lim";
	if ($_[2] =~ '#') {
	    $compound = $_[2];
	    @morfs = split("#",$_[2]);
	    $compound =~ s/\#//g;
	    print "$compound ";
	    foreach $morf (@morfs) {
		$morf =~ s/\*$//;
		$morf =~ s/-$//;
		$morf =~ s/s$//;
		print "$morf ";
	    };
	} else {
	    $_[2] =~ s/\*$//;
	    print "$_[2] ";
	};
    };
};

print "</document>\n";
print "</documents>\n";

#
#	6828    6828    main:>0 <Card> NUM NOM &NH
#</SIZEANNO>
#2       <p>     <p>             Lim
#</HEAD>
#1       <s>     <s>             Lim
#1       <       <
#2       BODY    body    main:>0 N NOM &NH
#3       ID="8:10        id=     mod:>2  <Card> NUM NOM &N<
#4       "
#5       >       >
#6       <s>     <s>             Lim
#<TEXT>
#1       <s>     <s>             Lim
#<RUBRIK>
#1       <s>     <s>             Lim
#1       VINSÄLJANDE     vin#säljande    attr:>2 NDE &>N
#2       HANDLARE        handlare                N NOM &NH
#3       BRÖT    bröt            N NOM &>N &N<
#4       MONOPOLET       monopol         N SG NOM &>N &NH
#:
