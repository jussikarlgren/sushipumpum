#!/usr/bin/perl
while (<>) {
    s/<html> <doc> /<html>\n<doc>\n/;
    s-</html>-\n</doc>\n</html>\n-; 
    s-\">-\">\n-;
print;
}
