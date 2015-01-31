#!/usr/bin/perl
#-------------------------------------
$lang = "sv";
@years = ("1994", "1995");
@months = ("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
foreach $year (@years) {
foreach $month (@months) {
$dir = "/hosts/krumelur/e2/clef/se/tt-distrib/$year/$month";
$target_dir = "/hosts/krumelur/e2/clef/se/tt-fdg/$year/$month";
$code_dir = "/hosts/krumelur/e2/clef/bin";
#-------------------------------------
$date = `date '+%y%m%d'`;
chop $date;
#-------------------------------------
opendir(DATADIR,$dir);
@DATAFILES = grep(/xml/,readdir(DATADIR));
closedir(DATADIR);
#------------------------------------
foreach $filename (@DATAFILES) {
    if ("$target_dir/$filename.fdg") {rename ("$target_dir/$filename.fdg", "$target_dir/$filename.$date.bak");};
    
    open(DATAFILE,"$dir/$filename");
    
    open(OUTFILE,">>$target_dir/$filename.fdg"); 
    select(OUTFILE); 
    $state = "untext"; 
    
    while (<DATAFILE>) {
	if (/^<\/BODY/) {
	    close OUTFILE;
	    $state = "untext"; 
	    $text =~ s/\<[^\>]*\>/\n/g ;	# remove tags
	    open(OUTPIPE,"| $lang-fdg 2> /dev/null >> $target_dir/$filename.fdg"); 
	    print OUTPIPE $text; 
	    close(OUTPIPE);	
	    $text = "";
	    open(OUTFILE,">>$target_dir/$filename.fdg"); 
	    select(OUTFILE); 
	};
	if ($state eq "text") {
	    $text = $text.$_;
	} else {
	    print;
	};
	if (/^<BODY/) {
	    $state = "text";
	};
    } # while <DATAFILE>
    close(DATAFILE);    
} # foreach datafile
} # foreach month
} # foreach year















