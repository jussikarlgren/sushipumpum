#!/usr/local/bin/perl
$/="\<\/DOC\>";
$*=1;
$fileoutput = 0;
$mwt = 1;
$mwtq = 0;
$tile = 0;
$stats = 0;
%abbrevs = ('a\.', 'a', 'a\.m\.', 'am', 'apr\.', 'apr', 'ariz\.', 'ariz', 'aug\.', 'aug', 'b\.', 'b', 'c\.', 'c', 'calif\.', 'calif', 'co\.', 'co', 'col\.', 'col', 'colo\.', 'colo', 'conn\.', 'conn', 'corp\.', 'corp', 'cpl\.', 'cpl', 'd\.', 'd', 'd\.c\.', 'dc', 'dec\.', 'dec', 'deg\.', 'deg', 'dr\.', 'dr', 'e\.', 'e', 'f\.', 'f', 'feb\.', 'feb', 'fla\.', 'fla', 'fr\.', 'fr', 'g\.', 'g', 'gen\.', 'gen', 'gov\.', 'gov', 'h\.', 'h', 'i\.', 'i', 'ii\.', 'ii', 'ill\.', 'ill', 'inc\.', 'inc', 'j\.', 'j', 'j\.c\.', 'jc', 'j\.p\.', 'jp', 'jan\.', 'jan', 'jr\.', 'jr', 'k\.', 'k', 'l\.', 'l', 'l\.a\.', 'la', 'l\.p\.', 'lp', 'ltd\.', 'ltd', 'm\.', 'm', 'maj\.', 'maj', 'mar\.', 'mar', 'mass\.', 'mass', 'md\.', 'md', 'mich\.', 'mich', 'minn\.', 'minn', 'mo\.', 'mo', 'mr\.', 'mr', 'mrs\.', 'mrs', 'ms\.', 'ms', 'n\.', 'n', 'n\.a\.', 'na', 'n\.c\.', 'nc', 'n\.j\.', 'nj', 'n\.v\.', 'nv', 'n\.y\.', 'ny', 'no\.', 'no', 'non-u\.s\.', 'non-us', 'nov\.', 'nov', 'o\.', 'o', 'oct\.', 'oct', 'ore\.', 'ore', 'p\.', 'p', 'p\.m\.', 'pm', 'pa\.', 'pa', 'pct\.', 'pct', 'plc\.', 'plc', 'pres\.', 'pres', 'prof\.', 'prof', 'pvt\.', 'pvt', 'q\.', 'q', 'qtr\.', 'qtr', 'r\.', 'r', 'rep\.', 'rep', 'rev\.', 'rev', 's\.', 's', 's\.a\.', 'sa', 'sen\.', 'sen', 'sept\.', 'sept', 'sgt\.', 'sgt', 'st\.', 'st', 'supt\.', 'supt', 't\.', 't', 'u\.', 'u', 'u\.k\.', 'uk', 'u\.n\.', 'un', 'u\.s\.', 'us', 'v\.', 'v', 'va\.', 'va', 'vs\.', 'vs', 'w\.', 'w', 'wash\.', 'wash', 'x\.', 'x', 'y\.', 'y', 'z\.', 'z');

$date = `date '+%y%m%d'`;
chop $date;

if ( $#ARGV == 0 ) { $datadir = "./data"; $expr = ".";}
else { $datadir = $ARGV[0];
$expr = $ARGV[1];
   };

opendir(DATADIR,$datadir);
@DATAFILES = grep(/$expr/,readdir(DATADIR));
closedir(DATADIR);


if ($tile && -e "tile_count.$date.$expr") {rename ("tile_count.$date.$expr","tile_count.$date.$expr.bak");}

if ($stats && -s "stats.$date.$expr") {rename ("stats.$date.$expr","stats.$date.$expr.bak");}

if ($fileoutput && -s "file.$date.$expr") {rename ("file.$date.$expr","file.$date.$expr.bak");}

if ($mwtq && -e "term_count.$date.$expr") {rename ("term_count.$date.$expr","term_count.$date.$expr.bak");}

if ($mwt && -e "terms.$date.$expr") {rename ("terms.$date.$expr","terms.$date.$expr.bak");}



FILETEST:
foreach $shortfilename (@DATAFILES) {
    $comp = 0;
    $filename = "local.$shortfilename";
    system "cp $datadir/$shortfilename ./$filename";
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
next if !/.*\<DOCNO\>\s+(\w+-\w+)\s+\<\/DOCNO\>/;
    $docno = $1;
    /(\<LP\>|\<TEXT\>)/;		
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
 
# debugging
	if ($fileoutput) {
	open(OUTFILE,">>file.$date.$expr"); 
	select(OUTFILE);	
	print "$docno ";
	print $text;
	print "\n";
	close(OUTFILE);	
	select(STDOUT);
    }
# statistics 
	if ($stats) {
	open(OUTFILE,">>stats.$date.$expr"); 
	select(OUTFILE);	
	print "$docno ";
	close(OUTFILE);	
	open(OUTPIPE,"| quality/stats.perl >> stats.$date.$expr"); 
	select(OUTPIPE);	
	print $text;
	print "\n";
	close(OUTPIPE);
	select(STDOUT);

    }				# end of if ($stats)

# call mwt
if ($mwtq) {
	open(OUTFILE,">>term_count.$date.$expr"); 
	select(OUTFILE);	
	print "$docno ";
	close(OUTFILE);	
	    open(OUTPIPE,"| /tomek.c/proteus/karlgren/TREC5/katzterms/mwt | /tomek.c/proteus/karlgren/TREC5/katzterms/term_count.perl >> term_count.$date.$expr"); 
	     select(OUTPIPE);	
	     print $text;
	     print "\n";
	     close(OUTPIPE);
    }


	if ($mwt) {
	    open(OUTFILE,">>terms.$date.$expr"); 
	    select(OUTFILE);	
	print "<DOC>\n<DOCNO>\n$docno\n</DOCNO>\n<TYPE>\nfrequent multi-word terms\n</TYPE>\n<TEXT>\n";
	close(OUTFILE);	
			open(OUTPIPE,"| /tomek.c/proteus/karlgren/TREC5/katzterms/mwt | /tomek.c/proteus/karlgren/TREC5/katzterms/term_cutoff.perl >> terms.$date.$expr"); 
	     select(OUTPIPE);	
	     print $text;
	     print "\n";
	     close(OUTPIPE);
		open(OUTFILE,">>terms.$date.$expr"); 
	select(OUTFILE);	
	print "</TEXT>\n</DOC>\n";
	close(OUTFILE);	
	}
	select(STDOUT);


# call tile
	if ($tile) {
	if (-e "tile/tile.in") {system "rm tile/tile.in";}
	open(OUTFILE,">tile/tile.in"); 
	select(OUTFILE);	
	print;
	print "\n";
	close(OUTFILE);	

	open(OUTFILE,">>tile_count.$date.$expr"); 
	select(OUTFILE);	
	print "$docno ";
	close(OUTFILE);	

	system "tile/tile -i tile/tile.in | tile/count_tiles.perl >>tile_count.$date.$expr"; 
	select(STDOUT);

    }



} # while <DATAFILE>

#    if ($comp) {system "compress $datadir/$filename";}

    system "rm $filename";

} # foreach datafile
exit(0);	


