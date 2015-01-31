#!/usr/local/bin/perl
$warn = 0;
$debug = 0;
$i=0;
$jmax = 0;

require "getopts.pl";
&Getopts('d');

$debug = 1 if ($opt_d);

while($line = <STDIN>)
{
$j=0;
    foreach $word (split(/\s+/,$line)) {
	next if $word eq "";
	$item[$i][$j] = $word;
	$row[$i] += $word;
	$col[$j] += $word;	
	$sum += $word;	
	$warn = 1 if ($word < 5);
	$j++;
    }
$jmax = $j if $j > $jmax; 
$i++;
}

$j = $jmax;

$df = ($i-1)*($j-1);			

$yates = 0;
if ($df == 1) {$yates = 0.5;} # "yates correction" for 2x2 tables.

$k = 0;
while ($k < $i) {
    $l=0;
    while ($l < $j) {
	$ev = $col[$l]*$row[$k]/$sum;
	$khi2 += (abs($item[$k][$l] - $ev) - $yates)**2/$ev;
	print "$ev " if $debug;
    $l++;
    }
    print "| $row[$k]\n"  if $debug;
    $k++;
}
$l = 0;

if ($debug) {
    print "___________________________________________\n";
    while ($l < $j) {print "$col[$l] "; $l++;}
    print "| $sum\n";
}



print "Yates correction employed for 2x2 contingency table.\n" if $yates;
print "There are cells with less than five individuals!\n" if $warn;
print "X2: $khi2\n";
print "df: $df\n";

if ($df == 4) {
    if ($khi2 > 18.5) {print "Significant (99.9%).\n";}
    elsif ($khi2 > 14.9) {print "Significant (99.5%).\n";}
    elsif ($khi2 > 13.3) {print "Significant (99%).\n";}
    elsif ($khi2 > 11.1) {print "Significant (97.5%).\n";}
    elsif ($khi2 > 9.49) {print "Significant (95%).\n";}
    elsif ($khi2 > 7.78) {print "Significant (90%).\n";}
    elsif ($khi2 > 3.36) {print "insignificant (50%).\n";}
}
if ($df == 3) {
    if ($khi2 > 12.838) {print "Significant (99.5%).\n";}
    elsif ($khi2 > 11.345) {print "Significant (99%).\n";}
    elsif ($khi2 > 9.348) {print "Significant (97.5%).\n";}
    elsif ($khi2 > 7.815) {print "Significant (95%).\n";}
    elsif ($khi2 > 6.251) {print "Significant (90%).\n";}
}
if ($df == 2) {
       if ($khi2 > 18.5) {print "Significant (99.9%).\n";}
    elsif ($khi2 > 10.6) {print "Significant (99.5%).\n";}
    elsif ($khi2 > 9.21) {print "Significant (99%).\n";}
    elsif ($khi2 > 7.38) {print "Significant (97.5%).\n";}
    elsif ($khi2 > 5.99) {print "Significant (95%).\n";}
    elsif ($khi2 > 4.61) {print "Significant (90%).\n";}
}
if ($df == 1) {
    if ($khi2 > 10.8) {print "Significant (99.9%).\n";}
    elsif ($khi2 > 7.88) {print "Significant (99.5%).\n";}
    elsif ($khi2 > 6.63) {print "Significant (99%).\n";}
    elsif ($khi2 > 5.02) {print "Significant (97.5%).\n";}
    elsif ($khi2 > 3.84) {print "Significant (95%).\n";}
    elsif ($khi2 > 2.71) {print "Significant (90%).\n";}
    elsif ($khi2 > 0.46) {print "Significant (50%).\n";}
}

print "PMI: ".$item[0][0]/($col[0]*$row[0])*$sum."\n";

exit(0);


