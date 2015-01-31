#!/usr/bin/perl

open(STOPLIST, "<it/stoplist.it");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

while(<>) {
    if (m-</top>-) {print "?\n";};
    $p = 1 if m=^<DE-title=;
    $p = 0 if m=^</DE-title=;
    $p = 1 if m=^<DE-desc=;
    $p = 0 if m=^</DE-desc=;
    next if m-<s>-;
    next if m-\.-;
    next if m-\?-;
    next unless $p;
    split;
    next if $stop{$_[1]};
    next unless $_[1];
# är det en sammansättning?
    if ($_[2] =~ '#') {
	$compound = $_[1];
	$compound =~ s/\#//g;
	print "$compound ";
# splitta den.
#	 @morfs = split("#",$_[1]);
#	 foreach $morf (@morfs) {
#	     $morf =~ s/\*$//;
#	     $morf =~ s/-$//;
#	     print "$morf ";
#	     if ($morf =~ m/s$/) {
#		 $morf =~ s/s$//;
#		 print "$morf ";
#	     };
#	 };
    } else {
	$_[1] =~ s/\*$//;
	print "$_[1] ";
    };
    


};
