#!/usr/bin/perl
# splitta aamu-filerna som innehåller en hel dags artiklar
open (FIL, "/tmp/dummy");
$directory = substr($ARGV[0],4,6);
print "$directory\n";
  while(<>) {
      next if m-^<doc>-;
      if (m+^<docid=(AAMU19[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9])>+) {
  	$filename = $1;
  	close (FIL);
  	open (FIL,">../aamu-split/$filename");
  	print FIL "<doc>\n";
      };
      print FIL $_;
  }
