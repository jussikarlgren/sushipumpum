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
# This program is developed by Jussi Karlgren, originally for
# teaching purposes, based on that publication and on discussions
# with Slava Katz at New York University in 1995
#
#------------------------------------
require "getopts.pl";
&Getopts('m:n:f:opcs');
#------------------------------------
if ( ($#ARGV < 1)  && ($#ARGV > 4) ) { 
print "Usage:       mwt filename -n min -m max -f threshold -o -p -c -s   \n";
print "									  \n";
print "		    filename   is a name of the text file to be processed \n";
#print "		    min        is the minimum length of the mwt           \n";
#print "		    max        is the maximum length of the mwt           \n";
#print "		    frequency  is the minimum frequency of the mwt        \n";
#print "			       for it to be counted.             	  \n";
#print "		    -o         if set, allows 'of' in the mwt             \n";
#print "		    -p         if set, allows prepositions in the mwt     \n";
#print "			       (subsumes -o)                     	  \n";
#print "		    -c         if set, allows conjunctions in the mwt     \n";
#print "		    -s         if set, allows subclauses in the mwt       \n";
#print "									  \n";
#print "Defaults: -n 2 -m 5 -f 2 -o         \n";
#print "									  \n";
}    
#==============================================================
$min = 3; $max = 5;$freq = 3; $preps = 1; $conjunctions = 0; $which = 0;
$freq = $opt_f if $opt_f;
$min = $opt_n if $opt_n;
$max = $opt_m if $opt_m;
$preps = 1 if $opt_o;
$preps = 2 if $opt_p;
$start{"DET"} = 1;
$start{"N"} = 1;
$start{"A"} = 1;
$start{"PRON"} = 1;
$start{"NUM"} = 1;
$start{"NDE"} = 1;
$start{"<Ord>"} = 1;
$mid{"DET"} = 1;
$mid{"N"} = 1;
$mid{"A"} = 1;
$mid{"NDE"} = 1;
$mid{"PRON"} = 1;
$mid{"NUM"} = 1;
$mid{"<Ord>"} = 1;
$end{"N"} = 1;
#$end{"A"} = 1;
if ($preps > 0) { $mid{"PREP"} = 1;}
if ($conjunctions > 0) { $mid{"CC"} = 1;}


#==============================================================
while (<>) {
    split;
    $word = $_[2];
    $mtags = $_[4];
    @m = split(" ",$mtags);
    $pos = $m[0];
    if ($mid{$pos}) {
	foreach $p (keys %prefixes) {
	    next unless $prefixes{$p} > 0;
	    $prefixes{$p." ".$word} = $prefixes{$p}+1;
	    $prefixes{$p} = 0;
	}
    } else {
	%prefixes = ();
    }
    if ($end{$pos}) {
	foreach $term (keys %prefixes) {
	    $mwt{$term}++ if $prefixes{$term} > 1;
	}
    }
    if ($start{$pos}) {
	$prefixes{$word} = 1;
    }
}
#==============================================================
foreach (sort {$mwt{$b} <=> $mwt{$a}} keys %mwt) {
    print "$mwt{$_} $_\n" if $mwt{$_} >= $freq;
}
#==============================================================
exit(0);

