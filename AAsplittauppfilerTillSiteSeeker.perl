#!/usr/bin/perl
# splitta aamu-filerna som innehåller en hel dags artiklar
# Jussi februari 2007, Tvarsokprojektet
open (FIL, "/tmp/dummy");
$directory = substr($ARGV[0],4,6);
$text = 1;
print "$directory\n";
  while(<>) {
      next if m-^<doc>-;
      if (/<notext>/) {
	  $text = 0;
	  next;
      }
      if (m-</notext>-) {
	  $text = 1;
	  next;
      }
      if (m/^<docid>(AAMU19[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9])/) {
  	$filename = $1;
	print FIL "</html>\n";
  	close (FIL);
  	open (FIL,">../aamu-split/$filename.html");
	print FIL "<html>\n";
	print FIL "<meta name=\"DC.identifier\" content=\"$filename\">\n";
  	print FIL "<doc>\n";
      }
      print FIL $_;
  }
