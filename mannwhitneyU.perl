#!/usr/bin/perl

#if ( $#ARGV == 0 ) { $datadir = "./data"; $expr = ".";}else { $datadir = $ARGV[0];$expr = $ARGV[1];   }

#$f1 = $ARGV[0];

require "getopts.pl";
&Getopts('c:l:v:dr:n:');


$critpos = $opt_c;
$valpos = $opt_v;
$debug = $opt_d;
if ($opt_r) {$rel = $opt_r;} else {$rel = 1;};
if ($opt_l) {$label_pos = $opt_l;} else {undef $label_pos; $label = "feature";};
if ($opt_n ne "") {$nonrel = $opt_n;};


$n = 0;
$k = 0;
print "n	n2		nx	sx	ny	sy\n" if $debug;
while(<>) {
    @_ = split;
    if ($label_pos && $_[$label_pos]) {$label = $_[$label_pos]; undef $label_pos;}
    next if $_[$critpos] ne $rel && ($nonrel ne "" && $_[$critpos] ne $nonrel);
    print "$n	$n2+$an*$an/$a	   $nx+$ax	$sx+$k*$ax	$ny+$ay	$sy+$k*$ay\n" if $debug;
    if ($_[$valpos] ne $prev) { 
#	if ($_[$valpos] > $prev) 
#	    if ($dir eq "desc") {
#		die "mwu: not sorted\n";
#	    } elsif !($dir) {
#		$dir = "asc";
#	    } 
	$k = $an / $a if $a;
	$n2 += $k*$k*$a;
	$nx += $ax;
	$sx += $k * $ax;
	$ny += $ay;
	$sy += $k * $ay;
	$prev = $_[$valpos];
	$ax = 0;
	$ay = 0;
	$an = 0;
	$a = 0;
    } ;
    $n++;
    $an += $n;		
    $a++;	       
	    if ($_[$critpos] eq $rel) {
		$ax++; 
		$truesx += $_[$valpos]; 
		$truesx2 += $_[$valpos]*$_[$valpos];} 
	    else {
		$ay++; 
		  $truesy += $_[$valpos];
		  $truesy2 += $_[$valpos]*$_[$valpos];}
	    $truesn += $_[$valpos];
	    $truesn2 += $_[$valpos] * $_[$valpos];

	}
		$k = $an / $a if $a;
		$n2 += $k*$k*$a;
		$nx += $ax;
		$sx += $k * $ax;
		$ny += $ay;
		$sy += $k * $ay;
	    print "$n	$n2		$nx	$sx	$ny	$sy\n" if $debug;

close(FN);

$bign = $nx + $ny;



print "Mann Whitney U: ";
if ($f1) {print "(file: $f1) ";}
print "$n cases ";
if ($n) {print "(",$truesn/$n," average)";}
print ", $nx relevant ";
if ($nx) {print "(",$truesx/$nx,")";}
print ", $ny non-relevant ";
if ($ny) {print "(",$truesy/$ny,")";}
print ".\n";

$w95 = $nx*($bign+1)/2+1.6449*sqrt($nx*$ny*($bign+1)/12);
$w05 = $nx*($bign+1) - $w95;
$w90 = $nx*($bign+1)/2+1.28*sqrt($nx*$ny*($bign+1)/12);
$w10 = $nx*($bign+1) - $w90;
$w75 = $nx*($bign+1)/2+0.675*sqrt($nx*$ny*($bign+1)/12);
$w25 = $nx*($bign+1) - $w75;

print "Rank sum: ($rel wrt $valpos - $label) $sx Criterion ";
if ($sx < $w05)
    {print "(95\%) < $w05 Result: YES: low.\n";} 
elsif ($sx > $w95) 
    {print "(95\%) > $w95 Result: YES: high.\n";} 
elsif ($sx < $w10)
    {print "(90\%) < $w10 Result: MAYBE: low.\n";} 
elsif ($sx > $w90) 
    {print "(90\%) > $w90 Result: MAYBE: high.\n";} 
elsif ($sx < $w25)
    {print "(75\%) < $w25 Result: HMM: low.\n";} 
elsif ($sx > $w75) 
    {print "(75\%) > $w75 Result: HMM: high.\n";} 
else {
{print "$w05 < $w10 < $w25 < || $sx || <  $w75 <  $w90 < $w95";}
print " Result: NO.\n";}

exit(0);

if ($n2*$nx*$ny*$bign > $n2*$nx*$ny) { # bign must be > 1; the others > 0

$estimate = ($sx - $nx*($bign + 1)/2)/sqrt($n2*$nx*$ny/($bign * ($bign - 1)) - $nx*$ny*($bign+1)*($bign+1)/(4*($bign-1)));

print "Normal estimate: $estimate Criterion (95\%): 1.6449";
if (abs($estimate) < 1.6449) {print " Result: NO.\n";} 
else {print " Result: YES2, ";
      if ($estimate > 0) {print "hi.\n";}      else {print "lo.\n"}}
}

if ($nx > 1 && $ny > 1) {

$xvariance = (($truesx2 - ($truesx*$truesx/$nx))/($nx-1));
$yvariance = (($truesy2 - ($truesy*$truesy/$ny))/($ny-1));
$samvarians = abs(($nx-1)*$xvariance + ($ny-1)*$yvariance)/($ny + $nx - 2);

$studentt = (($truesx/$nx) - ($truesy/$ny))/sqrt($samvarians*(1/$ny+1/$nx));
print "Student's t: ",$studentt," T criterion (95\%): 1.6449";
if (abs($studentt) < 1.6449) {
    print " Result: NO.\n";
} else {
    print " Result: YES3.\n";
}
}
