while (<>) {

    if (m=^(.*)<br ?/>=) {s/<[^>]+>/\ /g; s/^\s+//; s/\s+$//; if (length > 2) {print; print "\n";}}

}
