#!/usr/bin/perl

#hr kuls system vill ha filerna separerade.

#<DOCID>TT9495-940101-139972</DOCID>
open (FIL, "/tmp/dummy");
while(<>) {
    next if m-^<DOC>-;
    if (m+^<DOCID>(TT9495-(9[0-9])([0-9][0-9])([0-9][0-9])-[0-9][0-9][0-9][0-9][0-9][0-9])</DOCID>+) {
	$filename = "/hosts/krumelur/e2/clef/se/tt-fdg/19".$2."/".$3."/".$4."/".$1.".xml.fdg";
	close (FIL);
	open (FIL,">$filename");
	print FIL "<?xml version='1.0' encoding='iso-8859-1'?>\n";
	print FIL "<DOC>\n";
    };
    print FIL $_;
}

