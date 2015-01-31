#!/usr/bin/perl
#-------------------------------------
while (<>) {
    split;
    $_[0] =~ /WSJ(9\d)(\d\d)(\d\d)-(\d\d\d\d)/;
    $genre = $_[1];
    $year = "19".$1;
    $month = $2;
    $day = $3;
    $filename = "/src/harvahammas/corpora/en/WSJ/WSJ-fdg/$year/$month/$day/$_[0].fdg.xml";
    print "$filename\n";
}
















