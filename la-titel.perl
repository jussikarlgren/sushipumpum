#!/usr/bin/perl


  while(<>) {
      chop;
      $filename = $_;
      $tit = "";
      open (IN, "../LA/$filename");
      while ($k = <IN>) {
	  chop $k;
	  if ($k =~ m-HEADLINE-)	  {$on = 1; $k =~ s/<HEADLINE>//;};
	  $on = 0 if $k =~ m-/HEADLINE-;
	  next unless $on;
	  next if $k =~ m/<P>/;
	  next if $k =~ m-</P>-;
	  $tit = $tit." ".$k;
      };
    print "$_\t$tit\n";
  }

