#!/usr/bin/perl
#-------------------------------------
$lang = "en";
$target_dir = "/src/harvahammas/corpora/en/WSJ/lex/";
@years = ("1991");
@months = ("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
foreach $year (@years) {
foreach $month (@months) {
$dir = "/src/harvahammas/corpora/en/WSJ/WSJ-fdg/$year/$month";
print STDERR "$dir\n";
#-------------------------------------
opendir(DATEDIR,$dir);
@DATEFILES = grep(/[012]/,readdir(DATEDIR));
closedir(DATEDIR);
#------------------------------------
foreach $date (@DATEFILES) {
#------------------------------------
opendir(DATADIR,"$dir/$date");
@DATAFILES = grep(/xml/,readdir(DATADIR));
closedir(DATADIR);
#    if ("$target_dir/$year/$month/$year$month$day.fdg.xml") {rename ("$target_dir/$year/$month/$year$month$day.fdg.xml","$target_dir/$year/$month/$year$month$day.fdg.xml.$today.bak");};
#------------------------------------
foreach $filename (@DATAFILES) {
    open(DATAFILE,"$dir/$date/$filename");
    while (<DATAFILE>) {
	if (m-<TEXT>-) {
	    $text = 1;   
	    next;
	}
	if (m-</TEXT>-) {
	    $text = 0;   
	    next;
	}
	if (m-<LP>-) {
	    $rubrik = 1;   
	    next;
	}
	if (m-</LP>-) {
	    $rubrik = 0;   
	    next;
	}
	next unless ($text || $rubrik);
	split;
	$word = $_[1];
	next if $word eq "";
	next if $word eq "--";
	next if $word =~ /^[,<\.\"]/;
	$lemma= $_[2];
	$mtags = $_[6];
	if ($mtags eq "ING") {$mtags = "V";}
	if ($mtags eq "<Rel>") {$mtags = "PRON";}
	if ($mtags eq "Card") {$mtags = "NUM";}
	$tf{"$word	$lemma	$mtags"}++;
    }
    close(DATAFILE);    
} # foreach datafile
} # foreach datefile
open(OUTFILE,">>$target_dir/$month.lex"); 
select(OUTFILE); 
foreach $word (keys %tf) {
    print "$word	$tf{$word}\n";
}
    close(OUTFILE);
%tf = ();
} # foreach month
} # foreach year















