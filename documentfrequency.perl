#!/usr/bin/perl -w
# räkna df för orden. ett dokument per icke-newline rad
#

open(IN, "$ARGV[0]");
$/ ="\n";
while (<IN>) {
    @words = split(/\W*\s\W*/);
    undef %saw;
    @unique = grep(!$saw{$_}++, @words);
    foreach $word(@unique) {
	$df{$word}++;
    }
}

@sorted = map { { ($_ => $df{$_}) } } 
              sort { $df{$a} cmp $df{$b} or $a cmp $b } keys %df;

foreach $hashref (@sorted) {
    ($key, $value) = each %$hashref;
    printf "%-15s %d \n", $key, $value;
}
