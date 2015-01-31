#!/usr/local/bin/perl
# Jussi Karlgren, jussi@sics.se, 1997
# run with "perl ngram.perl -s STOPLIST -t THRESHOLD textfile"
#
#

# command line options
require "getopts.pl";
&Getopts('s:t:n:');
$number=12;
$number = $opt_n if $opt_n;
$threshold=2;
$threshold = $opt_t if $opt_t;


# reads a stoplist file
if ($opt_s) {
open(STOPLIST, "<$opt_s");  
while ($_ = <STOPLIST>) {
   ($str = $_) =~ s/\s//; 
   $str =~ tr/A-Z/a-z/;  
   $stop{$str} = 1;  
}
close STOPLIST;
}

# read entire paragraphs rather than just line by line
$*=1;
$/="\n\n";


# for each line (actually, paragraph, since $* was set above)
while(<>) {
    s/(<[^>]+>)//g;        # remove sgml/html tags
    s/[\#>\&\$]//g;        # remove line-initial comment tags
    s/\-\n//g; # fix line breaks
    s/[0123456789]//g;        # remove digits
    s/[\=\*\+]//g;        # remove asterisks and ascii art separators
    s/[\'\"\`\~]//g; # remove quotes and other non-characters
    s/[\\\/\-\_]/\ /g; # remove hyphens and slashes 
    s/[\}\{\[\],)(\"]/\ ; \ /g;	# remove punctuation (lesser)
    s/[;:!\?]/\ ;\ /g;	 # remove punctuation (sentence break) (turn them into ";")
    s/(\D)\.(\W)/$1\ $2/g; # remove punctuation (period - nondec)
    tr/A-Z/a-z/;            # lowercase 
  @array = split(/\s+/,$_); # split line (paragraph) into words 	
	for ($i=0;$i<=$#array-1;$i++) {   # for each word
	    next if $stop{$array[$i]};    # skip this word if it is in stoplist (never start an ngram with a stoplist word)
	    next if $array[$i] eq ";";    # if word is punctuation skip it
	    next if $array[$i+1] eq ";";  # don't ever end an ngram with a punctuation character
	    next if $stop{$array[$i+1]}; # don't ever end an ngram with a stoplist word
	$n2{"$array[$i] $array[$i+1]"}++;
	    next if $array[$i+2] eq ";";
	    next if $stop{$array[$i+2]};
	$n3{"$array[$i] $array[$i+1] $array[$i+2]"}++ unless $i > $#array-2;
	    next if $array[$i+3] eq ";"; 
	    next if $stop{$array[$i+3]};
	$n4{"$array[$i] $array[$i+1] $array[$i+2] $array[$i+3]"}++ unless $i > $#array-3;
	    next if $array[$i+4] eq ";";
	    next if $stop{$array[$i+4]};
	$n5{"$array[$i] $array[$i+1] $array[$i+2] $array[$i+3] $array[$i+4]"}++ unless $i > $#array-4;
}
}

$n = $number;
foreach $ngram (sort {$n2{$b} <=> $n2{$a}} keys %n2) {
    last if $n2{$ngram} < $threshold;
    print "$n2{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n3{$b} <=> $n3{$a}} keys %n3) {
    last if $n3{$ngram} < $threshold;
    print "$n3{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n4{$b} <=> $n4{$a}} keys %n4) {
    last if $n4{$ngram} < $threshold;
    print "$n4{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}
print "---\n";
$n = $number;
foreach $ngram (sort {$n5{$b} <=> $n5{$a}} keys %n5) {
    last if $n5{$ngram} < $threshold;
    print "$n5{$ngram}	$ngram\n";
    $n--;
    last if $n < 0;
}



exit(0);
