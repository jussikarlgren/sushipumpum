#!/usr/local/bin/perl
# fetches lexicon items from swedish-spanish onlajn lexicon at http://lexin.nada.kth.se/sve-spa.shtml

$AUTOFLUSH = 1;
require "getopts.pl";

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;

$fn=$ARGV[0];
open(FN,"<$fn");
$ua = LWP::UserAgent->new();
while ($query = <FN>) {
            chop $query;
    print "$query     ";
    sleep 3;
    $URL="http://lexikon.nada.kth.se/cgi-bin/sve-spa";
    my $req = POST $URL, [ uppslagsord => $query ];
    $content = $ua->request($req)->as_string;
    if (@ord = $content =~ m=ttning<DD><B>([^<]+)=) {
    $r = "";
    foreach $o (@ord) {
	$r = $r." $o";
    };		
    $r =~ s/;/\t/g;   
    print "($r)" if $r;	  
    };
    print "\n";
};





