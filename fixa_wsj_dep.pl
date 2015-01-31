# fixa_wsj_dep.pl

while (<>) {

    next if /^\(\)$/;

    ($mor, $fokus, $dottrar) = /^\((.*?)\) (.+?) \((.*?)\)$/;

    $mor =~ s/[()]//g;
    $fokus =~ s/[()]//g;
    $dottrar =~ s/[()]//g;


    print "($mor) $fokus ($dottrar)\n";
}
