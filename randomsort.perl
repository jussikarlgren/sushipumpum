#!/usr/bin/perl

while (<>) {
chop;
split;
$hash{$_[2]}++;
};

$i = 0;
foreach $item (keys %hash) {
	$i++;
	last if $i > 200;
	print "$item\n";
}
