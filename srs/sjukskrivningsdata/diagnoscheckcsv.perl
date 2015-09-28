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
$kg{$kommun}{$kon}{$kod}++;
$dk{$datum}{$kommun}{$kod}++;
$dks{$datum}{$kommun}{$kod} += $sgi;
$dkl{$datum}{$kommun}{$kod} += $brutto;
$kk{$kommun}++;
$dd{$datum}++;
}

print "\t;\t;";
for $kk (sort keys %kk ) {
    print "\t$kk-R;\t$kk-F;\t$kk-G;";
    print "\t$kk-R-sgi;\t$kk-F-sgi;\t$kk-G-sgi;";
    print "\t$kk-R-brutto;\t$kk-F-brutto;\t$kk-G-brutto;";
}
print "\n";

#-----

for $k (sort keys %dd) {
    print "$k;\t$dd{$k};\t";
for $kk (sort keys %kk ) {
    print "$d{$k}{$kk};\t";
    print "$dk{$k}{$kk}{symptom};\t";
    print "$dk{$k}{$kk}{psykiatri};\t";
    print "$dk{$k}{$kk}{neurologi};\t";
    print "$dks{$k}{$kk}{symptom};\t";
    print "$dks{$k}{$kk}{psykiatri};\t";
    print "$dks{$k}{$kk}{neurologi};\t";
    print "$dkl{$k}{$kk}{symptom};\t";
    print "$dkl{$k}{$kk}{psykiatri};\t";
    print "$dkl{$k}{$kk}{neurologi};\t";
    }
    print "\n";
}
