#m79 g93
while (<>) {
@f = split "\t";

next if $f[0] eq "lopnr";

$kon = $f[82];
($kommun) = $f[85] =~ /^(\d\d)/;

($datum) = $f[1] =~ /^(\d\d\d\d)-/g;

$sgi = $f[94];
$brutto = $f[8];


#if ($f[77] eq "M79") {$kod = fibromyalgi;}
#els
if ($f[77] eq "G93") {$kod = neurologi;}
elsif ($f[77] eq "F48") {$kod = psykiatri;}
elsif ($f[77] eq "R53") {$kod = symptom;}
else {next;}
#els
#if ($f[77] =~ /^F/) {$kod = psykiatri;}
#elsif ($f[77] =~ /^G/) {$kod = neurologi;}
#elsif ($f[77] =~ /^I/) {$kod = cirkulation;}
#elsif ($f[77] =~ /^M/) {$kod = muskel;}
#elsif ($f[77] =~ /^R/) {$kod = symptom;}
#else {$kod = annan;}

$d{$datum}{$kod}++;
$g{$kon}{$kod}++;
$k{$kommun}{$kod}++;
$kg{$kommun}{$kon}{$kod}++;
$kgp{$kommun}{$kon}{$kod} += $sgi;
$kgl{$kommun}{$kon}{$kod} += $brutto;
$dk{$datum}{$kommun}{$kod}++;
$gg{$kon}++;
$kk{$kommun}++;
$dd{$datum}++;
}
print "------------------------------------------\n";

for $k (sort keys %d) {
    print "$k\t$dd{$k}\n";
for $kk (sort keys %{ $d{$k} }) {
    print "\t$kk:$d{$k}{$kk}\t";
    for $kkk (sort keys %kk) {
	print "$kkk:$dk{$k}{$kkk}{$kk}\t";
    }
    print "\n";
}
    print "\n";
}
print "------------------------------------------\n";

for $k (sort keys %k) {
    print "$k\t$kk{$k}\t";
for $kk (keys %{ $k{$k} }) {
    print "$kk:$k{$k}{$kk}\t";
    for $kkk (keys %gg) {
	print "$kkk:$kg{$k}{$kkk}{$kk}\t";
    }
}
    print "\n";
}
print "------------------------------------------\n";

for $k (sort keys %k) {
    print "$k\t$kk{$k}\t";
for $kk (keys %{ $k{$k} }) {
    print "$kk:$k{$k}{$kk}\t";
    for $kkk (keys %gg) {
	if ($kg{$k}{$kkk}{$kk}) {print "$kkk:$kgp{$k}{$kkk}{$kk}/$kg{$k}{$kkk}{$kk}\t" } else {print "$kkk:0\t" }
    }
}
    print "\n";
}
print "------------------------------------------\n";

for $k (sort keys %k) {
    print "$k\t$kk{$k}\t";
for $kk (keys %{ $k{$k} }) {
    print "$kk:$k{$k}{$kk}\t";
    for $kkk (keys %gg) {
	if ($kg{$k}{$kkk}{$kk}) {print "$kkk:$kgl{$k}{$kkk}{$kk}/$kg{$k}{$kkk}{$kk}\t" } else {print "$kkk:0\t" }
    }
}
    print "\n";
}
print "------------------------------------------\n";
for $k (sort keys %g) {
    print "$k\t$gg{$k}\t";
for $kk (sort keys %{ $g{$k} }) {
    print "$kk:$g{$k}{$kk}\t";
}
    print "\n";
}
