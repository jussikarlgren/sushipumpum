#!/usr/bin/perl



while (<>) {
split;	   
$rank = $_[3];
next if $rank > 10;
$fnr = $_[2];
$fnr =~ m/TT9495-(\d\d)(\d\d)\d\d-\d+/;
$y = $1;
$m = $2;
	open (FIL,"/hosts/krumelur/e2/clef/se/tt-split/19$y$m/$fnr.xml");

while (<FIL>) {

    if (m/^<SPECIAL/) {next;};
    if (m/^<EDSTAT/) {next;};
    if (m/^<MODVER/) {next;};
    if (m/^<DEST/) {next;};
    if (m/^<FIFO/) {next;};
    if (m/^<FIFOVER/) {next;};
    if (m/^<SERVID/) {next;};
    if (m/^<NR/) {next;};
    if (m/^<PRODID/) {next;};
    if (m/^<DATESENT/) {next;};
    if (m/^<TIMESENT/) {next;};
    if (m/^<UNO/) {next;};
    if (m/^<RECVER/) {next;};
    if (m/^<TEXTTYP/) {next;};
    if (m/^<SLUGG/) {next;};
    if (m/^<URG/) {next;};
    if (m/^<SUBREF/) {next;};
    if (m/^<HSOURCE/) {next;};
    if (m/^<WRITER/) {next;};
    if (m/^<LANG/) {next;};
    if (m/^<SIZEMODE/) {next;};
    if (m/^<MAXSUBSIZE/) {next;};
    if (m/^<SIZEANNO/) {next;};
    if (m/^<ENDSIZE/) {next;};

print "$rank $_";
};

};
