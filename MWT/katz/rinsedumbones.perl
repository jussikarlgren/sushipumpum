#!/usr/local/bin/perl

open(STOPLIST, "<stoplist");  
while ($_ = <STOPLIST>) {
   ($str = $_) =~ s/\s//; 
   $str =~ tr/A-Z/a-z/;  
   $stop{$str} = 1;  
}
close STOPLIST;
 
open(OR_WORDS,"<or_words");  # override words 
while ($_ = <OR_WORDS>) {
   chop $_; ($str = $_) =~ tr/ //d; 
   $str =~ tr/A-Z/a-z/;  
   $stop{$str} = 0;  
   $or_words{$str} = 1; 
} 
close OR_WORDS;


dbmopen(%codes, "/tomek.c/proteus/katzs/mw/codes", 0644) ||
    die "Cannot open DBM"; 

RAD:
while (<>) {
    if (/^</) {print; next RAD;};
    if (/^PT3/) {print; next RAD;};
    if (/^frequent multi-word terms$/) {print; next RAD;};

    @array = split(/\s+/); # split line into words 

    $head = pop(@array);
    if ((&pcode($head) > 2) || (! &PASSED($head))) {next RAD;};

    foreach $word (@array) {  
	if (! &PASSED($word)) {next RAD;};
    }
	print;

} # while <>

exit(0);	

sub pcode {
    local($lword,$code) = (@_,99);
    $code = $codes{$lword};  
    if (($or_words{$lword} == 1) || ($code == undef)) {return 1}
    return $code;   
}

sub PASSED {
    local($lword,$code) = (@_,99); 
    $code = &pcode($lword);  
    if ( $stop{$lword} == 1 ) { return 0 };  
    if ( $lword > 0 ) { return 0 }; # test for numbers. /JUSSI
    if ( length($lword) < 2 ) { return 0 }; # single characters. /JUSSI
    if ( $code <= 3 ) { return 1 };  
    return 0;
}


