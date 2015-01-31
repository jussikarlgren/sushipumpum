#!/usr/bin/perl




while(<>) {
    next if /^<\?xml/;
    next if /^<documents numdocs/;
    next if m-</documents>-;
    if(m/newsprint/) { 
$location = $ARGV;
$suffix = 12;
$prefix = 19;
$filename = substr($location,$prefix);
$barefilename = substr($filename,0,length($filename)-$suffix);
$date = substr($filename,0,8);
$name = substr($barefilename,14);
print "<document type=\"newsprint\" name=\"$name\" date=\"$date\" location=\"$location\">\n";
    } else {
print; 
next; 
    };
};
