#!/usr/bin/perl

$tmp = ();
while (<>) {
split;
foreach (@_) {
   tr/A-ZÅÄÖ/a-zåäö/;
   next if /[\.,:;?!-]/;
   next if /</; 
    $tmp{$_}++;
}

}

$i=0;$b=0;open(O,">b0");
foreach $individual (sort {$tmp{$a} <=> $tmp{$b}} keys %tmp) {
    $i++;
    if ($i > 999) {close(O); $i=0; $b++; open(O,">b$b");     print "b$b\n";
};
    print O "$individual\n";
}
close(O);







