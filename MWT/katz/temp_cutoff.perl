#!/usr/local/bin/perl
while (<>) { $_ =~ split ; 
             shift(@_); 
             foreach (@_) {print  $_," ";} 
             print "\n"; 
	 }; 

exit(0);

