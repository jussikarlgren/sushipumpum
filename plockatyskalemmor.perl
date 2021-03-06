#!/usr/bin/perl
open(STOPLIST, "<stoplist.de");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

while(<>) {
if (m-<TEXT>-) {
    $text = 1;   
    next;
};
if (m-<LEAD>-) {
    $text = 1;   
    next;
};
if (m-<TITLE>-) {
    $text = 1;   
    next;
};
if (m-<TX>-) {
    $text = 1;   
    next;
};
if (m-<LD>-) {
    $text = 1;   
    next;
};
if (m-<TI>-) {
    $text = 1;   
    next;
};

if (m-</DOC>-) {
    print "\n\n";
    next;
};

next unless $text;

if (m-</TEXT>-) {
    $text = 0;   
    next;
};
if (m-</LEAD>-) {
    $text = 0;   
    next;
};
if (m-</TITLE>-) {
    $text = 0;   
    next;
};

if (m-</TX>-) {
    $text = 0;   
    next;
};
if (m-</LD>-) {
    $text = 0;   
    next;
};
if (m-</TI>-) {
    $text = 0;   
    next;
};

split;

next if  $stop{$_[1]};
	if ($_[1] =~ '#') {
	    $compound = $_[1];
	    @morfs = split("#",$_[1]);
	    $compound =~ s/\#//g;
	    print "$compound ";
	    foreach $morf (@morfs) {
		$morf =~ s/\*$//;
		$morf =~ s/-$//;
		print "$morf ";
		if ($morf =~ m/s$/) {
		    $morf =~ s/s$//;
		    print "$morf ";
		};
	    };
	} else {
	    $_[1] =~ s/\*$//;
	    print "$_[1] ";
	};

};
