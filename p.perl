#!/usr/bin/perl

while (<>) {
    chop;
    next if $_ eq "";
    next unless /\w+\t\w+/;
    split("	");
#1	TT9495-940101-139984	tt9495-940101-139984	main>0	@NH         Heur N UTR SG NOM
    if ($_[1] =~ /(TT9495-\d+-\d+)/)  {
	$tag = $_[4];
    print "$tag ";
    if ($tag =~ /(\+\w+)/) {print "\n$c"; $nametag{$c} = $1;};
    }
}
