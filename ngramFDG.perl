#!/usr/local/bin/perl
# Jussi Karlgren, jussi@sics.se, 1997




require "getopts.pl";
&Getopts('s:t:n:');
$number=12;
$number = $opt_n if $opt_n;
$threshold=2;
$threshold = $opt_t if $opt_t;
if ($opt_s) {
open(STOPLIST, "<$opt_s");  
while ($_ = <STOPLIST>) {
   ($str = $_) =~ s/\s//; 
   $str =~ tr/A-Z/a-z/;  
   $stop{$str} = 1;  
}
close STOPLIST;
}
#@array = ("dummy" , "dummy", "dummy", "dummy");

#==============================================================
while (<>) {
    split;
    $word = $_[2];
    next if $word eq ",";
    next if $word eq ".";
    next if $word eq "";
    next if $word eq " ";
    next if $word eq "<s>";
    next if $word eq "<p>";
    $n2{"$array[0] $word"}++;
    $n3{"$array[1] $array[0] $word"}++;
    $n4{"$array[2] $array[1] $array[0] $word"}++;
    $n5{"$array[3] $array[2] $array[1] $array[0] $word"}++;
    for ($i=3;$i>0;$i--) {
	$array[$i] = $array[$i-1];
    }
    $array[0] = $word;
}
$n = $number;
foreach $ngram (sort {$n2{$b} <=> $n2{$a}} keys %n2) {
    last if $n2{$ngram} < $threshold;
    print "$n2{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n3{$b} <=> $n3{$a}} keys %n3) {
    last if $n3{$ngram} < $threshold;
    print "$n3{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n4{$b} <=> $n4{$a}} keys %n4) {
    last if $n4{$ngram} < $threshold;
    print "$n4{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n5{$b} <=> $n5{$a}} keys %n5) {
    last if $n5{$ngram} < $threshold;
    print "$n5{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}



exit(0);
