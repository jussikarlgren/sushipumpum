#!/usr/bin/perl
while (<>) {
    s/[\$\%\=\+]//g;
    s/é/e/g; # e aigu
    s/ç/c/g; # ce cedille 
    s/ç/s/g; # portugues
    s/í/a/g; # i aigu
    s/µ/x/g;
    s/ö/ue/g;
    s/ô/o/g; # circumflex
    s/ü/ue/g;
    s/á/a/g; # a grave
    s/(<[^>]+>)//g;        # remove sgml/html tags
    s/&\w+;//g; # remove html entities
    s/^\W+//; # ltrim
    s/[\'\"\`\~]//g; # remove quotes and other non-characters
    s/[\\\/\-\_]/\ /g; # remove hyphens and slashes 
    s/[\}\{\[\],)(\"]/\ ,\ /g;	# remove punctuation (lesser)
    s/[;:!\?]/\ ;\ /g;	 # remove punctuation (sentence break)
    s/(\D)\.(\W)/$1\ ;$2/g; # remove punctuation (period - nondec) 
    tr/A-Z/a-z/;
    print if /^[a-z\ \.,;0-9\n]+$/;
    print "\n";
}

