#!/usr/bin/perl
# clefifiera.perl
# Jussi Karlgren 17 maj 2002
# gör om TT-filer till CLEF-format enligt CLEF-kansliets önskemål:

#Scripsit Martin Braschler:
#
#- we advertise our document collections as being SGML,
#   not XML. If an XML parser can validate them, that's of
#   course a bonus. However, your proposed format conatins
#   a lot of XML-specific empty tags (<tag/>), which will
#   break almost all SGML parsers. These have to be eliminated.
#   (Simplest solution: convert <tag/> to <tag></tag>)
#
#- there should be two tags, <DOCID> and <DOCNO>, both with
#   identical contents. I suggest the following pattern for
#   these:
#
#	       TT9495-YYMMDD-DDDDDD
#
#   e.g. TT9495-940101-000001 or TT9495-950612-000357
#
#- all charcters that are part of ISO-Latin-1 should be present
#   in non-entity form, and everything else should be proper
#   entities. This seems to be the case in the sample you sent
#   me, so this comment is just for eventualities.



while(<>) {
    if(m/^<TTNITF>/) { 
	print "<DOC>\n";
	next;
    }
    if(m-^</TTNITF>-) { 
	print "</DOC>\n";
	next;
    }
    if(m/^<\?xml/) { 
	next;
    }
    if(m/^<\!DOCTYPE/) { 
	next;
    }

    if(m/^<HEAD>/) { 
	$location = $ARGV;
#	$suffix = 12;
	$prefix = 11;
	$filename = substr($location,$prefix);
	$date = substr($filename,2,6);
	$code = substr($filename,8,6);

#	$barefilename = substr($filename,0,length($filename)-$suffix);
#	$name = substr($barefilename,14);

	$docno = "TT9495-$date-$code";
	print "<DOCID>$docno</DOCID>\n";
	print "<DOCNO>$docno</DOCNO>\n";
    }
# nix dos line feed
    s/\015//g;
# reformulate xml abbreviated end tags to full-length sgml end tags
    s-<(\w+)([^>/]*)/>-<$1$2></$1>-;
# substitute non latin-1 characters to sgml entities
#    s/\& /\&amp\; /;
    print;
}
