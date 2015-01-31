#!/usr/bin/perl
# jussi oct 21 2004 crystal city
# reassembles tags in gh-fdg corpus.
$a=0;
$untext=1;
%tag = (DOCNO, 1, DOCID, 1, DATE, 1, ARTICLETYPE, 1, BYLINE, 1, EDITION, 1, PAGE, 1, FLAG, 1, GRAPHIC, 1, RECORDNO, 1);

while(<>) {
    if (/<(\w+)>/ && $tag{$1}) {
	$a=$1;
	$at = "";
	next;
    }
    if (m-</$a>-) {
	print "<$a>$at</$a>\n";
	$a="";
	next;
    }
    if (m-<TEXT>-) {$untext=0;};
    if (m-</TEXT>-) {$untext=1;};
    if ($a) {
	next if /\d+\s+<s>\s+<s>/;
	split;
	if ($at) {
	    $at = $at." ".$_[1];
	} else {
	    $at = $_[1];
	}
    } else {
	if (/\d+\s+<(s|p)>\s+<(s|p)>/ && $untext) {next;}
	print;
    }
}
