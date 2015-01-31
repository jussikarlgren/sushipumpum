#!/usr/bin/perl
print "#!/bin/bash\n";
$x = "\"<?xml version=\\\"1.0\\\" encoding=\\\"ISO-8859-1\\\"?>\"";
while ($fnr = <>) {
    chop $fnr;
    $fnr =~ m/TT9495-(\d\d)(\d\d)(\d\d)-\d+/;
    $y = $1;
    $m = $2;
    $d = $3;
    print "echo $x > tmp; cat /Shared/data/corpora/sv/tt-distrib/19$y/$m/$d/$fnr.xml >> tmp; mv tmp /Shared/data/corpora/sv/tt-distrib/19$y/$m/$d/$fnr.xml\n";
};
