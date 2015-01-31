#!/usr/bin/perl
# Jussi Karlgren, SICS, 2003. jussi@sics.se
#---------------------------------------------------------------------
# Use this script as you see fit. 
# No thanks necessary; bug reports gratefully accepted; 
# complaints disregarded.
#---------------------------------------------------------------------
# Put data in a file with items on separate lines, 
# categorial information in one column and values in another;
# sort file by value. 
#
# Usage: kruskalwallis.perl -c <Categorial_Column> -v <Value_Column>
# with columns numbered from 0 up.
#
require "getopts.pl";
&Getopts('c:v:d');

$critpos = $opt_c;
$valpos = $opt_v;
$debug = $opt_d;


$n = 0;
$k = 0;

while(<>) {
    split;
    if (!($dir) && $prev && $_[$valpos] > $prev) {
	$dir = 1;
    };
    if (!($dir) && $prev && $_[$valpos] < $prev) {
	$dir = -1;
    };

    if ($dir < 0 && $_[$valpos] > $prev) {
	die "kruskal-wallis: not sorted at $n ($_[$valpos] > $prev)\n";
    } elsif ($dir > 0 && $_[$valpos] < $prev) {
	die "kruskal-wallis: not sorted at $n ($_[$valpos] < $prev)\n";
    };

    $crit = $_[$critpos];

    if ($_[$valpos] ne $prev) { 
	$k   =  $an / $a if $a;
	$an   =  0;
	$a   =  0;
	foreach $c (keys %a) {
	    $n{$c}  += $a{$c};
	    $r{$c}  += $k * $a{$c};
	    $a{$c}  =  0;
	};
	if ($debug && $n > 0) {
	    print "$n $prev\t";
	    foreach $x (keys %n) {
		print "  $x: $n{$x} $s{$x}/$n{$x} $r{$x}\t";
	    };
	    print "\n";
	};
	$prev   =  $_[$valpos];
     };
    $n++;
    $an += $n;		
    $a++;	       

    $a{$crit}++;
    $s{$crit}  += $_[$valpos]; 
    $s2{$crit}  += $_[$valpos]*$_[$valpos];
    $sn += $_[$valpos];
    $sn2 += $_[$valpos] * $_[$valpos];
};

$k   =  $an / $a if $a;
foreach $c (keys %a) {
    $n{$c}  += $a{$c};
    $r{$c}  += $k * $a{$c};
    $a{$c}  =  0;
};

close(FN);

if ($debug) {
    print "$n $prev\t";
    foreach $x (keys %n) {
	print "  $x: $n{$x} $s{$x}/$n{$x} $r{$x}\t";
    };
    print "\n\n";
};



print "Kruskal Wallis: ";
print "$n cases ";
if ($n) {
    print "(",$sn/$n," average)";
};
foreach $x (keys %n) {
    print ", $x: $n{$x} items ";
    if ($n{$x}) {
	print "(average ",$s{$x}/$n{$x},"; rank sum ",$r{$x},")";
    };
};
print ".\n";

$df = 0;
$hl = 0;
foreach $x (keys %r) {
    if ($n{$x}) {
	$hl +=  $r{$x}*$r{$x}/$n{$x};
    };
    $df++;
};

$H = 12*$hl/($n*($n+1))-3*($n+1) if $n;
$df--;
print "Kruskal-Wallis test statistic: $H - refer to khi2 tables with $df degrees of freedom.\n";

exit(0);
