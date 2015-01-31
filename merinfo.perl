#!/usr/bin/perl

while (<>) {
    $rad = $_;
    if($rad =~ m/location=\"([\w\d\/\.])\"/) { 
	$file = $1;
	open (LOC,"tt-orig/".$file);
	while (<LOC>)  {
	    m/DOCID=""/;
	    $docid = $1;
	    m/PRODID=""/;
	    $prodid = $1;
	};
	close(LOC);
	chop $rad;
	chop $rad;
	print $rad." DOCID=$docid PRODID=$prodid>\n";
    } else {
	print $rad; 
	next; 
    };
};
