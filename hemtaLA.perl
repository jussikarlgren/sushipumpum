#!/usr/bin/perl


  while(<>) {
      chop;
  	$filename = $_;
	$directory = substr($filename,0,8);
	@argument = ("cp", "/hosts/krumelur/e2/clef/en/LA/$directory/$filename", "./LA/$filename");
	system(@argument);
  	print $_;
  }
