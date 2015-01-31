#!/usr/bin/perl
# splitta SDA-filerna som innehåller en hel dags artiklar
# Jussi mars 2007, Tvarsokprojektet
open (FIL, "/tmp/dummy");
print FIL "<html>\n";
$text = 0;
while(<>) {
     next if m-^<DOC>-;
    if (m-<DOCNO>(.+)</DOCNO>-) {
	$docno = $1;   
	print FIL "</html>\n";
  	close (FIL);
  	open (FIL,">$docno.html");
	print FIL "<html>\n";
  	print FIL "<doc>\n";
	print FIL "<META name=\"DC.identifier\" content=\"$docno\">\n";
	next;
    }
    if (m/<TI>/) {
	$text = 1;   
	next;
    }
    if (m/<TX>/) {
	$text = 1;   
	next;
    }
    if (m/<LD>/) {
	$text = 1;   
	next;
    }
    if (m/<ST>/) {
	$text = 1;   
	next;
    }
    next unless $text;
    if (m-</TI>-) {
	$text = 0;   
	next;
    }
    if (m-</LD>-) {
	$text = 0;   
	next;
    }
    if (m-</TX>-) {
	$text = 0;   
	next;
    }
    if (m-</ST>-) {
	$text = 0;   
	next;
    }
    print FIL $_;
}
print FIL "\n";
print FIL "</doc></html>\n";
