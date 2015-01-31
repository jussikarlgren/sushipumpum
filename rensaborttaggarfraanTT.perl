#!/usr/bin/perl
# Jussi Karlgren 13 juni 2002



while(<>) {

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

    s/<HEADLINE ID=\"2:105\">/<HEADLINE>/;
    s/<BODY ID=\"8:10\">/<BODY>/;

    print;
}
