#!/usr/bin/perl

while (<>) {
#<DOCNO> LA010194-0001 </DOCNO>
#<DOCID>TT9495-940101-139972</DOCID>
    if (m!^<DOC>!) {next;};
#    if (m!^<DOCNO> (LA\d\d\d\d\d\d-\d\d\d\d) </DOCNO>!) {
    if (m!^<DOCID>(TT9495-\d\d\d\d\d\d-\d\d\d\d\d\d)</DOCID>!) {
        close(FIL);
        open(FIL,">$1.fdg.xml");
        print FIL "<DOC>\n";
    };
    print FIL $_;
};

