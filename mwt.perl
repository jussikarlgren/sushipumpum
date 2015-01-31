#!/usr/local/bin/perl
# Jussi Karlgren, SICS
#------------------------------------
# MWT (multi-word term) is a program for finding topically used multi word
# terms in running text, using lexical and statistical calculation.
# The original idea was first presented by Slava Katz and John Justeson
# in an IBM Research report in 1993 and later published as
# John Justeson and Slava Katz. 1995. Technical terminology:                  
# some linguistic properties and an algorithm for identifying in text.  
# Natural Language Engineering: 1, 1, 9-27.
#                                                                             
# This program is based on that publication and on code written by
# Slava Katz at New York Univesity in 1995, but developed further by
# Jussi Karlgren, originally for teaching purposes.
#------------------------------------
require "getopts.pl";
&Getopts('m:n:f:opcs');
#------------------------------------
if ( ($#ARGV < 1)  && ($#ARGV > 4) ) { 
print "Usage:       mwt filename -n min -m max -f threshold -o -p -c -s   \n";
print "									  \n";
print "		    filename   is a name of the text file to be processed \n";
print "		    min        is the minimum length of the mwt           \n";
print "		    max        is the maximum length of the mwt           \n";
print "		    frequency  is the minimum frequency of the mwt        \n";
print "			       for it to be counted.             	  \n";
print "		    -o         if set, allows 'of' in the mwt             \n";
print "		    -p         if set, allows prepositions in the mwt     \n";
print "			       (subsumes -o)                     	  \n";
print "		    -c         if set, allows conjunctions in the mwt     \n";
print "		    -s         if set, allows subclauses in the mwt       \n";
print "									  \n";
print "Defaults: -n 2 -m 5 -f 2 -o         \n";
print "									  \n";
print "MWT expects to find a lexicon file in the running directory.       \n";
print "If no file is found, -p -c and -s have no effect and some other    \n";
print "quality filters fail.\n";
exit;
}    
#==============================================================
$min = 3; $max = 5;$freq = 3; $preps = 1; $conjunctions = 0; $which = 0;
$freq = $opt_f if $opt_f;
$min = $opt_n if $opt_n;
$max = $opt_m if $opt_m;
$preps = 1 if $opt_o;
$preps = 2 if $opt_p;
$start_threshold = 0;
#==============================================================
#initialize dictionary
%start = {};
%mid = {};
%end = {};
open(LEX, "</Shared/data/corpora/en/engfunc.lex");  
while (<LEX>) {
    split;
    $end{$_[0]} = -1; # no word in this list is a legal end of mwt 
    if ($_[1] eq "poss" || $_[1] eq "det") {
	$start{$_[0]} = 1;
	$mid{$_[0]} = 1;
    } elsif ($_[1] eq "aux") {
	$start{$_[0]} = -1;
	$mid{$_[0]} = -1;
    } else {
	$start{$_[0]} = -1;
	$mid{$_[0]} = 1;
    }
}
close LEX;
# sentence break merits its own spot in the lex
$start{";"} = -1;
$mid{";"} = -1;
$end{";"} = -1;
$start{","} = -1;
$mid{","} = -1;
$end{","} = -1;
#==============================================================
# read in entire paragraphs
$*=1;
$/="\n\n";
while (<>) {
    # preprocess data
    s/(<[^>]+>)//g;        # remove sgml/html tags
    s/[\#>\&\$]//g;        # remove line-initial comment tags
    s/\-\n//g; # fix line breaks
    s/[0123456789]//g;        # remove digits
    s/[\=\*\+]//g;        # remove asterisks and ascii art separators
    s/[\'\"\`\~]//g; # remove quotes and other non-characters
    s/[\\\/\_]/\ /g; # remove slashes (preserve hyphens)
    s/[\}\{\[\],)(\"]/\ \,\ /g;	# normalize punctuation (lesser)
    s/[;:!\?]/\ ;\ /g;	 # normalize punctuation (sentence break)
    s/(\D)\.(\W)/$1\ $2/g; # remove punctuation (period - nondec)
    tr/Ö/Åˆ/;            # mac coding (caps)
    tr/éåäö/eÅÂÅ‰Åˆ/;            # mac coding
    tr/A-Z/a-z/;            # lowercase 
    @words = split(/\s+/,$_); # split line into words 
    for ($position=0;$position < $#words-$min; $position++) {
#	print "\n$position: ";
	$word = $words[$position];
	next if $start{$word} < $start_threshold; # is this word known to be a nonstarter?
	next if $word > 0; # test for numbers.
	next if length($word) < 2; # single characters. 
	$emax = $position+$max; 
	$emin = $position+$min-1;
	if ($emax > $#words) {$emax = $#words} 
	for ($ee = $position+1; $ee <= $emax; $ee++) { 
#	    print "$ee? ";
	    $last = $words[$ee];
# for each ee check to see if it is kosher to pass over it.
# (shud be: ok for det only if preceded by prep!)
	    if ($mid{$last} < 0) {
#		print "x[$last]";
		$position = $ee;
		last;
	    } 
# don't store unless we have passed min spot
	    next if $ee < $emin;
# for each ee check to see if it is kosher to end here.
	    next if $end{$last} < 0;
            # success. note this one.
	    $term = join(' ',@words[$position..$ee]);
#	    print "$ee ($term)! ";
	    $mwt{$term}++;
	} # for ee
    } # for position
}
#==============================================================
foreach (sort {$mwt{$b} <=> $mwt{$a}} keys %mwt) {print "$mwt{$_} $_\n" if $mwt{$_} >= $freq;}
#==============================================================
exit(0);




#
#
#        if ( $part_of_speech{$frag[$jj]} > 2 ) {next}  # last is not noun 
#        if ( $preps >= 1 ) {
#          $n_preps = 0;
#          for ($kk = $ii+1; $kk <= $jj-1; $kk++) {
#            if ( $prep{$frag[$kk]}) { 
#              $n_preps++; 
#              if (($n_preps > 1) || ($part_of_speech{$frag[$kk-1]} > 2)) {next LOOP_B} 
#            } 
#          } # end of $kk for-loop
#          if ($n_preps > 1) {next} 
#        } # end of if ($preps >= 1)
