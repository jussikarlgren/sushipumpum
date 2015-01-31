#!/usr/bin/perl
##
##  reymers matchbokning
##

# en lista med matcher, en lista med datum och en med motspelare
#    @matchlista = split;
#    @datum = split;
#    @motspelare = split;
#@matchlista = (Enskede, Drakensberg);
#@datum = ("030425","030503");
#@motspelare = (Enskede,"Reymers lag 5");
#
## en lista med spelare och en med tröjnummer
#
#@namn = (Truls, Tedde, Axel);
#@spelare = (12,14,3);
#
## en lista av listor med deltagarinformation
##
##while (<>) {
##    @tmp = split;
## poppa av namn och tröjnummer
##    push @AoA, [ @tmp ];
##}
##
#@delta = (["ja", nej], [nej, ja]);

open(DB,"reymers.db");
while (<DB>) {
    @rad = split;
    if ($rad[0] eq "Match") {shift @rad; push @matchlista @rad;next;};
    if ($rad[0] eq "Datum") {shift @rad; push @datum;next;};
    if ($rad[0] eq "Motspelare") {shift @rad; push @motspelare;next;};
    $tmp = shift @rad;
    push @namn, $tmp;
    $tmp = shift @rad;
    push @spelare, $tmp;
    push @delta, [ @rad ];
};
close(DB);
print "Content-type: text/plain\n\n";

print "<form>\n";
print "<table border=\"1\"> \n";
print "<tr> <th>Spelare</th> <td>Namn</td>\n";
for ($i = 0; $i <= $#matchlista; $i++) {
    print "    <td>$matchlista[$i]<br>$datum[$i]<br>$motspelare[$i]</td> \n";
};
print "</tr>\n";
for ($j = 0; $j <= $#spelare; $j++) {
    print "<tr> <th>$spelare[$j]</th> <td>$namn[$j]</td> ";
    for ($i = 0; $i <= $#matchlista; $i++) {
	print "    <td ";
	if ($delta[$j][$i] eq "ja") {
	    print "bgcolor=\"#00FF00\" ";
	} elsif ($delta[$j][$i] eq "nej") {
	    print "bgcolor=\"#FF0000\" ";
	} else {
	    print "bgcolor=\"#FFFFFF\" ";
	};
	print ">$delta[$j][$i]</td> \n";
    }
    print "</tr>\n";
}
print "</table>\n";

