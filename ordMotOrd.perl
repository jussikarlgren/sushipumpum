#!/usr/bin/perl
# tar utmatning från ordford.perl och visar samband mellan två ord.
# för clef 2004
# jussi maj 2004

$i=0;
while (<>) {
    if (/([åäö\w]+):/) {
	$rank{$1} = $i;
	$ord[$i++] = $1;
	split("	");
	shift @_;
	$w{$1}=[ @_ ];
    };
};
$o1 = "brand";
$o2 = "handla";

print "$o1 $o2 $rank{$o1} $rank{$o2} $ord[$rank{$o1}] $ord[$rank{$o2}] $w{$ord[$rank{$o1}]}[$rank{$o2}] $w{$ord[$rank{$o2}]}[$rank{$o1}] $w{$ord[$rank{$o1}]}[$rank{$o1}] $w{$ord[$rank{$o2}]}[$rank{$o2}]\n";

#for ($i=0;$i<@ord.length;$i++) {@xx=$w{$ord[$i]}; $x=$xx[3]; print "$i	$ord[$i]	$x\n" unless $ord[$i] eq "";};

