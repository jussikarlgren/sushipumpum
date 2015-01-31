#!/usr/local/bin/perl



require "getopts.pl";
&Getopts('s:');

if ($opt_s) {
open(STOPLIST, "<$opt_s");  
while ($_ = <STOPLIST>) {
   ($str = $_) =~ s/\s//; 
   $str =~ tr/A-Z/a-z/;  
   $stop{$str} = 1;  
}
close STOPLIST;
}

open(OUTFILE,">/usr/tmp/outfile"); 
select(OUTFILE);

$*=1;
$/="\n\n";

while($line = <STDIN>)
{
    $line =~ s/(<[^>]+>)//g;        # remove sgml/html tags
    $line =~ s/[\'\"\`\~]//g; # remove quotes and other non-characters
    $line =~ s/[\\\/\-\_]/\ /g; # remove hyphens and slashes 
    $line =~ s/[\}\{\[\],)(\"]/\ ,\ /g;	# remove punctuation (lesser)
    $line =~ s/[;:!\?]/\ ;\ /g;	 # remove punctuation (sentence break)
    $line =~ s/(\D)\.(\W)/$1\ ;$2/g; # remove punctuation (period - nondec)
    $line =~ tr/A-Z/a-z/;            # lowercase 
  @array = split(/\s+/,$line); # split line into words 	
  foreach $word (@array) {  
	print $word,"\n" if !$stop{$word};
}
}

close OUTFILE; 
select(STDOUT);

exec("sort /usr/tmp/outfile | uniq -c | sort -nr") || die "Can't sort/uniq: $!\n"; 

exit(0);
