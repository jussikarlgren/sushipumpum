#!/usr/bin/perl
#-------------------------------------
$lang = "en";
$dir = "/hosts/krumelur/e2/clef/$lang/LA";
$target_dir = "/hosts/krumelur/e2/clef/$lang/LA-fdg3";
#-------------------------------------
opendir(DATEDIR,$dir);
@DATEFILES = grep(/LA/,readdir(DATEDIR));
closedir(DATEDIR);
#-------------------------------------
$today = `date '+%y%m%d'`;
chop $today;
#------------------------------------
foreach $date (@DATEFILES) {
#------------------------------------
opendir(DATADIR,"$dir/$date");
@DATAFILES = grep(/LA/,readdir(DATADIR));
closedir(DATADIR);

    $date =~ /LA(\d\d)(\d\d)(\d\d)/; 
    $month = $1;
    $day = $2;
    $year = "19".$3;
    if ("$target_dir/$year/$month/$year$month$day.fdg.xml") {rename ("$target_dir/$year/$month/$year$month$day.fdg.xml","$target_dir/$year/$month/$year$month$day.fdg.xml.$today.bak");};
#------------------------------------
foreach $filename (@DATAFILES) {
    open(DATAFILE,"$dir/$date/$filename");
    open(OUTFILE,">>$target_dir/$year/$month/$year$month$day.fdg.xml"); 
    select(OUTFILE); 
    $state = "untext"; 
    
    while (<DATAFILE>) {
	if (m-^</HEADLINE- || m-^\</TEXT-) {
	    $state = "untext";
	    close OUTFILE;
	    $text =~ s/\<[^\>]*\>/\n/g ;	# remove tags
	    open(OUTPIPE,"| /opt/conexor/en/fdg3/$lang-fdg3 --text >> $target_dir/$year/$month/$year$month$day.fdg.xml"); 
	    print OUTPIPE $text; 
	    close(OUTPIPE);	
	    $text = "";
	    open(OUTFILE,">>$target_dir/$year/$month/$year$month$day.fdg.xml"); 
	    select(OUTFILE); 
	};
	if ($state eq "text") {
	    $text = $text.$_;
	} else {
	    print unless $state eq "discard";
	};
	if (/^<HEADLINE/) {
	    $state = "text";
	};
	if (/^<TEXT/) {
	    $state = "text";
	};
    } # while <DATAFILE>
    close(DATAFILE);    
} # foreach datafile
} # foreach datefile















