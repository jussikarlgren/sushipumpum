#!/usr/local/bin/perl
# Jussi Karlgren, jussi@sics.se, 1999

$*=1;
$/="\n\n";
$id = 0;

while($line = <>) {
    next unless $line;	
    $line =~ s/[\'\"\`\~\\\/\-\_]/\ /g; # remove hyphens and slashes 
    $line =~ s/[\}\{\[\],)(\.\;:!\?§]//g;
#    $line =~ s/(\D)\.(\W)//g; # remove punctuation (period - nondec)
    $line =~ tr/A-Z/a-z/;            # lowercase 
    @array = split(/\s+/,$line); # split line into words 	
    foreach $word (@array) {  
	if ($first{$word}) {
	    $last{$word} = $id;
	    $this{$word}++;
	} else {
	    $first{$word} = $id;
	    $last{$word} = $id;
	    $this{$word} = 1;
	};
    };
    if (eof) {
	$id++;
	foreach (keys %this) {
	    $df{$_}++;
	    $wdf{$_} += $this{$_};
	};
	%this = ();
    };
}

foreach (sort keys %first) {
    print "$_ $first{$_} $last{$_} ",$last{$_}-$first{$_}," $df{$_} $wdf{$_} ",$df{$_}/$id," ",$wdf{$_}/$id,"\n" unless $last{$_} == $first{$_};
};

exit(0);

