#!/usr/bin/perl
open(STOPLIST, "<stoplist.fr");  
while (<STOPLIST>) {
chop;
    $stop{$_} = 1;  
}
close STOPLIST;

while(<>) {
if (m-<TEXT>-) {
    $text = 1;   
    next;
};
if (m-<LEAD1>-) {
    $text = 1;   
    next;
};
if (m-<TITLE>-) {
    $text = 1;   
    next;
};
if (m-<TX>-) {
    $text = 1;   
    next;
};
if (m-<LD>-) {
    $text = 1;   
    next;
};
if (m-<TI>-) {
    $text = 1;   
    next;
};

if (m-</DOC>-) {
    print "\n";
    next;
};

next unless $text;

if (m-</TEXT>-) {
    $text = 0;   
    print "\n";
    next;
};
if (m-</LEAD1>-) {
    $text = 0;   
    print "\n";
    next;
};
if (m-</TITLE>-) {
    $text = 0;   
    print "\n";
    next;
};

if (m-</TX>-) {
    $text = 0;   
    print "\n";
    next;
};
if (m-</LD>-) {
    $text = 0;   
    print "\n";
    next;
};
if (m-</TI>-) {
    $text = 0;   
    print "\n";
    next;
};

split;
print "$_[1] " unless $stop{$_[1]};
};
