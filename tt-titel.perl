#!/usr/bin/perl


  while(<>) {
      chop;
      $filename = $_;
      $tit = "";
      open (IN, "../TT/$filename");
      while ($k = <IN>) {
	  if ($k =~ m+^<HEADLINE ID="2:105">([\"\?\!\+\';\(\)\,…\.\:\w≈ƒ÷\ \-]*)</HEADLINE>+) {
	      $tit = $1;
	  };
      };
    print "$_\t$tit\n";
  }

