#!/usr/bin/perl
# to fdg process the alldocs file nick belkin sent me sep 2004
# jussi karlgren
# sics 22 sep 2004
#-------------------------------------
$lang = "en";
$dir = ".";#/home/jussi/Hard_Corpus/genre_experiment/";
$targetdir = "./fdg"; #/home/jussi/Hard_Corpus/genre_experiment/";
$a = mkdir "./fdg";
unless ($a) {
    print "felfelfel ./fdg\n";
}
#------------------------------------
opendir(DATADIR,".");
@DATAFILES = grep(/nyt/,readdir(DATADIR));
closedir(DATADIR);
#------------------------------------
foreach $filename (@DATAFILES) {
    $filename =~ m-nyt2003(\d\d\d\d)-;
    $date = $1;
    unless (-e "$targetdir/$date") {
	$a = mkdir "$targetdir/$date";
	unless ($a) {
	    print "felfelfel $targetdir/$date\n";
	}
    }
    open(DATAFILE,"<$dir/$filename");
    open(OUTFILE,">>$targetdir/$date/$docno.fdg"); 
    $state = "untext"; 
    while (<DATAFILE>) {
#<DOCNO> nyt199902050394 </DOCNO>
	if (m-<DOC id=\"(NYT\d+\.\d+)\"-) {
	    $docno = $1;
	    open(OUTFILE,">$targetdir/$date/$docno.fdg"); 
	    select(OUTFILE); 
	    print "<DOC>\n";
	    print;
	    print "<BODY>\n";
	}
	if (m-^</HEADLINE-){
	    print;
	    $state = "discard";
	    next;
	}
	if (m-^</TEXT-){
	    $state = "discard";
	    $text =~ s/\<[^\>]*\>/\n/g ;	# remove tags
	    $text =~ s/\&\w+;//g ;	# remove html entities
	    print "<TEXT>\n";
	    open(OUTPIPE,"| /usr/local/conexor/en/fdg/en-fdg "); #2>/dev/null >> $targetdir/$date/$docno.fdg"); 
	    print OUTPIPE $text; 
	    close(OUTPIPE);	
	    open(OUTFILE,">>$targetdir/$date/$docno.fdg"); 
	    select(OUTFILE); 
#	print "$docno\n";
	    print "</TEXT>\n</BODY>\n</DOC>\n";
	    close(OUTFILE);
	    $text = "";
	    next;
	}
	if ($state eq "text") {
	    $text = $text.$_;
	} else {
	    s/\<[^\>]*\>/\n/g ;	# remove tags
	    s/\&\w+;//g ;	# remove html entities
	    print unless $state eq "discard";
	}
	if (/^<HEADLINE/) {
	    $state = "headline";
	}
	if (/^<TEXT/) {
	    $state = "text";
	}
    } # while <DATAFILE>
    close(DATAFILE);    
}













