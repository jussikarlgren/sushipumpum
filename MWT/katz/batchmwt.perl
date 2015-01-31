#!/usr/local/bin/perl

$mwt = 1;

$min = 2; $max = 5; $preps = 0;

%abbrevs = ('a\.', 'a', 'a\.m\.', 'am', 'apr\.', 'apr', 'ariz\.', 'ariz', 'aug\.', 'aug', 'b\.', 'b', 'c\.', 'c', 'calif\.', 'calif', 'co\.', 'co', 'col\.', 'col', 'colo\.', 'colo', 'conn\.', 'conn', 'corp\.', 'corp', 'cpl\.', 'cpl', 'd\.', 'd', 'd\.c\.', 'dc', 'dec\.', 'dec', 'deg\.', 'deg', 'dr\.', 'dr', 'e\.', 'e', 'f\.', 'f', 'feb\.', 'feb', 'fla\.', 'fla', 'fr\.', 'fr', 'g\.', 'g', 'gen\.', 'gen', 'gov\.', 'gov', 'h\.', 'h', 'i\.', 'i', 'ii\.', 'ii', 'ill\.', 'ill', 'inc\.', 'inc', 'j\.', 'j', 'j\.c\.', 'jc', 'j\.p\.', 'jp', 'jan\.', 'jan', 'jr\.', 'jr', 'k\.', 'k', 'l\.', 'l', 'l\.a\.', 'la', 'l\.p\.', 'lp', 'ltd\.', 'ltd', 'm\.', 'm', 'maj\.', 'maj', 'mar\.', 'mar', 'mass\.', 'mass', 'md\.', 'md', 'mich\.', 'mich', 'minn\.', 'minn', 'mo\.', 'mo', 'mr\.', 'mr', 'mrs\.', 'mrs', 'ms\.', 'ms', 'n\.', 'n', 'n\.a\.', 'na', 'n\.c\.', 'nc', 'n\.j\.', 'nj', 'n\.v\.', 'nv', 'n\.y\.', 'ny', 'no\.', 'no', 'non-u\.s\.', 'non-us', 'nov\.', 'nov', 'o\.', 'o', 'oct\.', 'oct', 'ore\.', 'ore', 'p\.', 'p', 'p\.m\.', 'pm', 'pa\.', 'pa', 'pct\.', 'pct', 'plc\.', 'plc', 'pres\.', 'pres', 'prof\.', 'prof', 'pvt\.', 'pvt', 'q\.', 'q', 'qtr\.', 'qtr', 'r\.', 'r', 'rep\.', 'rep', 'rev\.', 'rev', 's\.', 's', 's\.a\.', 'sa', 'sen\.', 'sen', 'sept\.', 'sept', 'sgt\.', 'sgt', 'st\.', 'st', 'supt\.', 'supt', 't\.', 't', 'u\.', 'u', 'u\.k\.', 'uk', 'u\.n\.', 'un', 'u\.s\.', 'us', 'v\.', 'v', 'va\.', 'va', 'vs\.', 'vs', 'w\.', 'w', 'wash\.', 'wash', 'x\.', 'x', 'y\.', 'y', 'z\.', 'z');

$date = `date '+%y%m%d'`;
chop $date;


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

&INITIALIZE_DICTIONARY; 

# COMLEX data are in ... 
# ... /griffin.b/proteus/grishman/comlex/verification/inflection.comlex
# DBM file with possible POS codes (1 to 5): 
# ... /tomek.c/proteus/katzs/mwt/codes.dir and codes.pag
# ... The corresponding associate array is %codes is initialized by the  
# ... following statement:

dbmopen(%codes, "/tomek.c/proteus/katzs/mw/codes", 0644) ||
        die "Cannot open DBM"; 

$/="\<\/DOC\>";
$*=1;

if ( $#ARGV == 0 ) { $datadir = "./data"; $expr = ".";}
else { $datadir = $ARGV[0];
$expr = $ARGV[1];
   };

opendir(DATADIR,$datadir);
@DATAFILES = grep(/$expr/,readdir(DATADIR));
closedir(DATADIR);


if ($mwt && -e "terms.$date.$expr") {rename ("terms.$date.$expr","terms.$date.$expr.bak");}



FILETEST:
foreach $remotefilename (@DATAFILES) {
    $comp = 0;
    $filename = "local".$remotefilename;
    system "cp $datadir/$remotefilename ./$filename";
    system "chmod 600 $filename";
    @fnl = split(/\./,$filename);
    $suffix = pop(@fnl);

    if ($suffix eq "z") 
    {system "gunzip $filename";
	    chop $filename;
	    chop $filename;
	    $comp = 1;};
    if ($suffix eq "Z") 
    {system "uncompress $filename";
	    chop $filename;
	    chop $filename;
	    $comp = 1;};	 

    next FILETEST unless -T $filename;

    open(DATAFILE,$filename);
    print $filename," ";

INLINE:
while (<DATAFILE>) {
# (ziff pattern) next if !/.*\<DOCNO\>\s+(\w+-\w+-\w+)\s+\<\/DOCNO\>/;
# (wsj pattern) next if !/.*\<DOCNO\>\s+(\w+-\w+)\s+\<\/DOCNO\>/;
    $docno = $1;
    /(\<LP\>|\<SUMMARY\>|\<TEXT\>)/;		
    $radstor = $';
    @rads = split(/\n\n/,$radstor);
    @texts = (); $cj = 0;
foreach (@rads) {

#preprocessor
	s/\<[^\>]*\>//g ;	# remove tags
	s/-\n/-/g;		# join hyphenated words at line breaks
#	s/\n/\ /g;		# join line breaks
	s/[\}\{\[\],)(\"]/\ ,\ /g;		# remove punctuation (lesser)
	s/[;:!\?]/\ ;\ /g;		# remove punctuation (sentence break)
        $text1 = $_;
        foreach $abb (keys %abbrevs) {$text1 =~ s/(\b )$abb/$1 $abbrevs{$abb}/ig;};
#        $text1 =~ s/([^0-9])\.(\s+[A-Z])/$1\ ;$2/g;	# remove punctuation (period - nondec)
        $text1 =~ s/\./\ ;\ /g;	# remove punctuation (period - nondec)
	$text1 =~ tr/A-Z/a-z/;		# lowercase 
    @texts[$cj] = $text1; 
    $cj++;
} #foreach $rad (@rads)
$text = join("\n\n",@texts);
 

# call mwt

open(OUTFILE,">>terms.$date.$expr"); 
select(OUTFILE);	
print "<DOC>\n<DOCNO>\n$docno\n</DOCNO>\n<TYPE>\nfrequent multi-word terms\n</TYPE>\n<TEXT>\n";
close OUTFILE;

				# 
open(OUTFILE2,">terms.$date.$expr.outfile"); 
select(OUTFILE2);

$rest = (); $zz = 0; 
@array = split(/\s+/,$text); # split line into words 
for ($ii = 0; $ii <= $#array; $ii++) { 
    if (length($array[0]) == 0) {shift @array} else {last};  
}				
@array = (@rest,@array); # add in front leftovers from previous line 
@frag = ();
foreach $word (@array) {  
    $word =~ tr/A-Z/a-z/;  
    if (&PASSED($word)) { @frag = (@frag,$word) } 
    else         { if (@frag != ()) { &PROCESS; @frag = () } }; # 
}				# 
@rest = @frag;

if ( @frag != () ) { &PROCESS(@frag) };  
	
close OUTFILE2; 


system("sort terms.$date.$expr.outfile | uniq -c | sort -nr | term_cutoff.perl >> terms.$date.$expr");



open(OUTFILE,">>terms.$date.$expr"); 
select(OUTFILE);	
print "</TEXT>\n</DOC>\n";
close(OUTFILE);	


select(STDOUT);





} # while <DATAFILE>

#    if ($comp) {system "compress $datadir/$filename";}

    system "rm $filename";

} # foreach datafile
exit(0);	

###############################################################################
#                                                                             #
# MWT is a program aiming at identifying topically used technical terminology #
# in text. It is based on structural (simple noun phrases) and discourse      #
# (repetition) properties of multi-word terms. These properties along with    #
# the algorithm utilizing them were first presented in                        #
#                                                                             #
# John S. Justeson and Slava M. Katz. Technical terminology:                  #
# some linguistic property and algorithm for identifying in text.             #
# IBM Research Report xxxx, 1993.                                             #
#                                                                             #
# An updated version of the paper was published under the same title in       #
# Natural Language Engineering: 1(1), 9-27 (1995).                            #
#                                                                             #
# MWT is based on the material presented in these publications.               #
#                                                                             #
###############################################################################
#                                                                             #
# Usage:       mwt file_name [ min_length max_length  preps ]                 #
#                                                                             #
#                                                                             #
#                                                                             #
#              file_name  is a name of the text file to be processed          #
#                         the file is assumed to be tokenized                 #
#              min_length is the minimum number of words in a term            #
#              max_length is the maximum number of words in a term            #
#              preps      is either 0 - no prepositions allowed,              #
#                                or 1 - only "of" is allowed,                 #
#                                or 2 - all prepositions are allowed.         #
#                                                                             #
###############################################################################


sub INITIALIZE_DICTIONARY {  

# COMLEX data are in ... 
# ... /griffin.b/proteus/grishman/comlex/verification/inflection.comlex
# DBM file with possible POS codes (1 to 5): 
# ... /tomek.c/proteus/katzs/mwt/codes.dir and codes.pag
# ... The corresponding associate array is %codes is initialized by the  
# ... following statement:

    dbmopen(%codes, "/tomek.c/proteus/katzs/mw/codes", 0644) ||
            die "Cannot open DBM"; 

}

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
    if (($preps >= 1) && ($lword eq "of")) { return 1 };
    if (($preps == 2) && ($code == 4)) { return 1 };
    return 0;

}

sub PROCESS {

    local($jj_lim, $n_preps);  
    if (($#frag+1) < $min) { return }; 
    LOOP_B: for ($ii = 0; $ii <= ($#frag-$min+1); $ii++) { # thru beginnings
      if (&pcode($frag[$ii]) == 4) {next}; # 1st is prep 
      $jj_lim = $ii+$max-1; 
      if ($jj_lim > $#frag) {$jj_lim = $#frag}; 
      LOOP_E: for ($jj = $ii+$min-1; $jj <= $jj_lim; $jj++) { # thru ends 
        if ( &pcode($frag[$jj]) > 2 ) {next};  # last is not noun 
        if ( $preps >= 1 ) {
          $n_preps = 0;
          for ($kk = $ii+1; $kk <= $jj-1; $kk++) {
            if ( &pcode($frag[$kk]) == 4 ) { 
              $n_preps++; 
              if (($n_preps > 1) || (&pcode($frag[$kk-1]) > 2)) {next LOOP_B}; 
            } 
          } # end of $kk for-loop
          if (($prep_err > 0) || ($n_preps > 1)) {next}; 
        } # end of if ($preps >= 1)
        foreach $ll ($ii .. $jj) {
          if ($ll != $ii) { print  " " };  
          print  $frag[$ll];
          if ($ll == $jj) {print "\n"} 
        } # end of foreach-loop 
      } # end of LOOP_E loop 
    } # end of LOOP_B loop    

}

