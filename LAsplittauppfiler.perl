#!/usr/bin/perl

#för iclef vill vi ha filerna separerade.

open (FIL, "/tmp/dummy");
$directory = substr($ARGV[0],0,8);
$directory =~ tr/la/LA/;
#mkdir("../LA/$directory","ug+rwx");
print "$directory\n";
  while(<>) {
      next if m-^<DOC>-;
      if (m+^<DOCNO> (LA[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]) </DOCNO>+) {
  	$filename = $1;
  	close (FIL);
  	open (FIL,">LA/$directory/$filename");
  	print "LA/$directory/$filename\n";
  	print FIL "<DOC>\n";
      };
      print FIL $_;
  }
