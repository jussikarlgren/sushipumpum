#!/usr/bin/perl

while (<>) {
#<DOCNO> LA010194-0001 </DOCNO>
    if (m!^<DOC>!) {next;};
    if (m!^<DOCNO> (LA\d\d\d\d\d\d-\d\d\d\d) </DOCNO>!) {
        close(FIL);
        open(FIL,">$1.fdg.xml");
        print FIL "<DOC>\n";
    };
    print FIL $_;
};

