#!/usr/local/bin/perl
while (<>) { $_ =~ split ; 
            if (@_[0] > 1) 
            {$cc++; 
             shift(@_); 
             foreach (@_) {print  $_," ";} 
             print "\n"; 
	 };}; 
# print "<TERM_COUNT>\n",$cc,"\n</TERM_COUNT>\n"; 

exit(0);

