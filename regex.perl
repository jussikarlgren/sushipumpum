while (<>) {
    if (m/(^|\s+)(tedde|jussi)[0-9]+($|\s+)/) {print "ok, $2!\n";}
}
