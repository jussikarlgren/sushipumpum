#!/usr/local/bin/perl
require "getopts.pl";
&Getopts('d');
if ($opt_d) {$debug = 1;};


# AP880212-0005  0.583333333333333 584 0.547945205479452 0.148972602739726 4.64897260273973 0.00110497237569061 21.6296296296296 0.0102739726027397 0.00342465753424658 0.0513698630136986 0.00342465753424658 0 0.00171232876712329 0.00171232876712329 0 0.0154109589041096  A 0 
# 251.docs www.es.emr.ca/ingd/rrapp3.html 1 0.393333333333333 1247 0.2485966319166 0.198075380914194 4.83961507618284 0.0096106048053024 103.916666666667 0.00240577385725742 0 0.00160384923817161 0.00320769847634322 0 0 0 0.00160384923817161 0 

@pos = (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38);
#@pos = (1,2,3,4);
#$rels = 1;


open(DATA,"<headers");
while (<DATA>) {
     split;
     $lbl[$i] = $_[0];
     $i++;
 };
close(DATA);
#@lbl = sort @lbl1;

foreach $x (@pos) {$max[$x]=0; $min[$x] = 1048576; }; 

if ($rels) {
    while (<>) {
	split; 
	$k = pop(@_);
    	if ($k == 1) { 
	    $aa++; foreach $x (@pos) { $a{$x} += $_[$x]; }; 
	} elsif ($k == -1) { 
	    $bb++; foreach $x (@pos) { $d{$x} += $_[$x]; }; 
	} elsif ($k == 0) { 
	    $cc++; foreach $x (@pos) { $c{$x} += $_[$x]; }; };
    };
    print "rels   $aa ";
    if ($aa) {
	foreach $x (@pos) { print $a{$x}/$aa," ";}; print "\n";
    };
    print "nonrels $bb ";
    if ($bb) {
	foreach $x (@pos) {  print $d{$x}/$bb," ";}; print "\n";
    };
    print "zips   $cc ";
    if ($cc) {
	foreach $x (@pos) { print $c{$x}/$cc," ";}; print "\n";
    };
} else {
    while (<>) {
	next if $_ eq "";
	next if /\^#/;
	split; 
	$aa++; 
	foreach $x (@pos) {
	    print "$x-";
	    next if $_[$x] eq "";
	    if ($_[$x]>$max[$x]) {
		$max[$x] = $_[$x]; $maxhit[$x] = 1;}
	    elsif ($_[$x]==$max[$x]) {
		$maxhit[$x]++;};
	    if ($_[$x]<$min[$x]) {
		$min[$x] = $_[$x]; $minhit[$x] = 1;}
	    elsif ($_[$x]==$min[$x]) {
		$minhit[$x]++;};
	    $a{$x} += $_[$x]; 
	    $a2{$x} += $_[$x]*$_[$x]; 
	};
    };
   print "tot   $aa ";
	print "\n";
    if ($aa) {
	foreach $x (@pos) { 
 	    print "$lbl[$x] ",$a{$x}/$aa;
# 	    print "$x ",$a{$x}/$aa;
	    print " ",sqrt(($a2{$x}-$a{$x}*$a{$x}/$aa)/($aa-1));
	    if ($range) {
		print " ($min[$x] (",int(10000*$minhit[$x]/$aa)/100,"%) - $max[$x] (",int(10000*$maxhit[$x]/$aa)/100,"%))";
	    };
	    print "\n";}; 
    };
};


