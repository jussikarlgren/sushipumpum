open D, "<maka_make_derived_from_huvudpersoner.sorterad.bada.txt";
while (<D>) {
my @v = split;
$gift{$v[0]}{$v[1]}++;
$gift{$v[1]}{$v[0]}++;
}
close D;

open E, "<make_maka.txt";
while (<E>) {
my @v = split;
unless ($gift{$v[0]}{$v[1]} || $gift{$v[1]}{$v[0]}) {print "fynd!  gift $v[0] o $v[1]\n";}
}
close E;

