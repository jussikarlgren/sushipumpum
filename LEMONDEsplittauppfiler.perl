#!/usr/bin/perl

#för iclef vill vi ha filerna separerade.

open (FIL, "/tmp/dummy");
$directory = substr($ARGV[0],0,8);
#mkdir("../lemonde95-split/$directory");
print "$directory\n";
  while(<>) {
      next if m-^<DOC>-;
      if (m+^<DOCNO>LEMONDE95-([0-9][0-9][0-9][0-9][0-9][0-9])</DOCNO>+) {
  	$filename = "LEMONDE$directory-$1.xml";
	print "done.\n";
  	close (FIL);
  	open (FIL,">../lemonde95-split/$directory/$filename");
  	print "lemonde95-split/$directory/$filename ...";
	print FIL "<?xml version='1.0' encoding=\"ISO-8859-1\"?>\n";
  	print FIL "<DOC>\n";
      };
      print FIL $_;
  }
