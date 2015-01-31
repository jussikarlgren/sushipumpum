#!/usr/local/bin/perl
#
# Copyright 1999 World Wide Web Consortium,
# (Massachusetts Institute of Technology, Institut
# National de Recherche en Informatique et en
# Automatique, Keio University). All Rights Reserved.
# This program is distributed under the W3C's
# Intellectual Property License. This program is
# distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See W3C License
# http://www.w3.org/Consortium/Legal/ for more details.
#
##############################################################################
#
# slidemaker tool
# split a all.html into slide*.html
#
# Stephan Montigaud - stephan@w3.org
# created 970601
# modified by Pierre Fillault
# check the documentation at http://www.w3.org/Talks/YYMMsub/
#
# modified 19990505 Bert Bos: ALT text of prev/next arrows is now
# "prev"/"next" rather than the title of the prev/next slide; looks better
# in lynx.
#
# version: 4.14 - 19990719
# $Id: slidemaker-mod.tar,v 1.1 2003/11/12 12:55:42 jussi Exp $
#
# modified 19990921 Jussi Karlgren: some english copulae taken out.
# modified 19990921 Jussi Karlgren: *.htm to *.html
# modified 20020131 Jussi Karlgren: $next, $prev, and $top introduced for header tags for baselang sensitivity
#
# NOTE: all the anchors in this tool contain the extension
# indeed this package has to work outside the environment of a web server
# Users need to be able to display their presentation using file:\\
# which requires link to 'real' files

##############################################################################
## default values of variables
##

## default DOCTYPE added on the slides
$doctype = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
    "http://www.w3.org/TR/REC-html40/loose.dtd">';

## name of raw HTML file containing the slides
$all = 'all.html';

## table of content built from all.html - also first page of the presentation
## this is only the basename as we need to generate one toc for each style sheets
## the main toc will not bear any more so the server can understand a request for '/'
## the next ones will bear a number corresponding to the slide index
$overview = 'Overview';

## name of the file containing the parameters of the presentation
$infos = 'infos.txt';

#	 ## the icons will be present at this default location
#	 $left  = '/~jussi/bin/slidemaker/Icons/left.gif';
#	 $right = '/~jussi/bin/slidemaker/Icons/right.gif';
#	 $top   = '/~jussi/bin/slidemaker/Icons/up.gif';
#	 $bar   = '/~jussi/bin/slidemaker/Icons/bar.gif';
#	 $barl  = '/~jussi/bin/slidemaker/Icons/barl.gif';

## default accesskeys for navigation icons used in the slides
$prevKey  = 'P';	# accesskey for previous slide
$nextKey  = 'N';	# accesskey for next slide
$tocKey   = 'C';	# accesskey for table of contents
$styleKey = 'S';	# accesskey for changing style sheets

## default author name
$author = 'W3C Staff';

## default presentation title
$talkTitle = 'W3C Talk';

## standard style sheets 
$cssStandardFiles = '/home/jussi/bin/slidemaker/Tools/w3ctalk-800w.css';
if (! -d '/home/jussi/bin/slidemaker/Tools') {
	## online location for W3C use
	$cssStandardFiles = '/Talks/Tools/w3ctalk-640w.css,/Talks/Tools/w3ctalk-800w.css,/Talks/Tools/w3ctalk-1024w.css';
}

## default charset use in meta tag http-equiv
$charset = 'ISO-8859-1';

## default language setting is English 
$baselang = 'en-US';

## HTML page color characteristics (background, text, link, visited link, active link)
#$body = '<body bgcolor="#000060" text="#ffffff" link="#ffffe8" vlink="#eeffee" alink="#ff0000">';
$body = '<body>';

## end of default values for the presentation
##############################################################################

##############################################################################
## reading user input from $infos
##
@PARAM = @ARGV; # we keep this for backward compatibility with an old version
                # of the slidemaker tool
                #when the parameters were in Makefile or make.bat

# read parameters from infos.txt and put them in @PARAM
if (open(INFOS, $infos)) {
    print STDOUT "--- Reading parameters file $infos ---\n";
    local(@file,$counter);
    $counter = 0;
    @file = <INFOS>;
    @PARAM = ();
    do {
	if ($file[0] =~ /^[^#\n\r]/) {
	   $file[0] =~ s/\n//;    # remove UNIX \n 
	   $file[0] =~ s/\r//;    # remove WINDOWS \r    
	   $file[0] =~ s/ *= */=/;
	   $PARAM[$counter++] = $file[0];
	   print "$file[0]\n";
	}
    } while (shift(@file));
}
## @PARAM is now a table with the user preferences for their presentation

## process arguments
## each preset variable is now re-attributed using the user preferences
foreach (@PARAM) {
    @_ = split(/ *= */);
    $cmd="\$$_[0] = \'$_[1]\';";
    if (length $_[1] != 0) { 
	eval($cmd);
    }
}


## save the style sheet file locations into tables 
@cssStandard = split(',',$cssStandardFiles);
$nbCssStandard = $#{@cssStandard} +1;
@cssUser = split(',',$cssUserFiles);
$nbCssUser = $#{@cssUser} +1;

## build an html string for the author variable
## containing the presentation author name linked to
## a location of his choice
if ($authorUrl) {
    $author = "<a href=\"$authorUrl\">$author</a>";
}

## same string is built if there is a second author for the presentation 
if ($author2 && $author2Url) {
    $author2 = "<a href=\"$author2Url\">$author2</a>";
}

## put both authors together
if ($author2) {
    $author = $author." &amp; ".$author2;
}
##############################################################################
# language specific header tags

    if ($baselang eq "se") {
	$next = "N�sta";
	$prev = "F�rra";
	$top = "Topp";
	$overview = "�versikt";
} else {
	$next = "Next";
	$prev = "Previous";
	$top = "Top";
	$overview = "Overview";
};
##############################################################################
## read the raw html presentation
##

## copy file in memory
my $sep = $/;
$/ = undef;
if (!open(ALL, $all)) {
    print "Error: Cannot open file: $all\n";
    exit 0;
}
my $buf = <ALL>;
close(ALL);
$/ = $sep;

## Remove comments from the raw presentation
## they do not need to show up on the slides
$buf =~ s/<!--.*?-->//sgo;

## the slidemaker tool assumes that each slide is self contained between 2 sets of h1 tags
## if not it will generate a rather weird output
## split using <h1...> and </h1...> as separator (ignores attributes!)
## h1 or H1 can be used
@table = split(/<\/?[hH]1[^>]*>/, $buf);

## compute the total number of slides
$total = $#table / 2;
if ($#table % 2 != 0) {
	$total = ($#table +1)/2;
}

##
## raw presentation has been read successfully
##############################################################################

##############################################################################
## processing the slides
 
print STDOUT "\n--- Processing $total slides ---\n"; 

## generate the header table of content of the presentation
## which is also the first page of the talk
&openOverview($overview);

## start the slide count so we can number them
$slideCount = 1;


## @table is the array containing each slide with its title
## for each slide to be generated
## we delete each slide and its title when generated
## so that the current slide and its title are always at $table[0] (for the title)
## and $table[1] (for the slide content)
do {

    ## get rid of the first element contained by the raw presentation array
    shift(@table);
    ## then $table[0] is the title of the slide to be generated
    $table[0] =~ s/\n+/ /g;    ## replace return character by a white space 
    $table[0] =~ s/ +/ /g;     ## concatenate several white spaces to only one
    $table[0] =~ s/^ //;       ## remove all the starting white spaces in the title
    $table[0] =~ s/ $//;       ## remove all trailing white spaces in the title
    ## $slideTitle preserves link(s) in the title
    $slideTitle = $table[0];
    ## need to check if the title contains any anchor
    ## if so it needs to be removed
    ## because the title is being used in the table of content to link to the corresponding slide
    $table[0] =~ s/(.*)<A[^>]*>(.*)<\/A>(.*)/$1$2$3/i;

    ## grab next slide title $table[2] (if there's a next slide)
    ## to be able to use in the 'next' navigation button
    ## keep in mind that $table[1] contains the slide corresponding to the title $table[0]
    $next_slide_title = $table[2] if $table[2];
    ## remove any anchor from the next slide title
    $next_slide_title =~ s/(.*)<A[^>]*>(.*)<\/A>(.*)/$1$2$3/i;

    ## add the title of the current slide to the table of content
    &addTitle("$table[0]",$slideCount);

    ## the current slide content is stored $table[1]
    ## there is an attempt to make sure it's clean HTML
    ## Pierre Fillault's note: use same piece of as used in http://www.w3.org/Web/Tools/CvsCommitScripting
    ## to make use of the validation service
    $slideContent = &clean_html($table[1]) ;

    ## generate the current slide
    ## parameters are:
    ## title of the slide, its content, the slide number, the title of the previous slide and the title of the next slide
    &createSlide("$slideTitle",$slideContent ,$slideCount++,$previous_slide_title,$next_slide_title);

    ## save the title of the previous slide to be displayed in the 'previous' navigation button
    $previous_slide_title="$table[0]";
}
## process the next slide 
while (shift(@table));

## close the table of content
&closeOverview;

## generate more toc with the all the style sheets
## as there's no way of loading a style sheet
## except dynamically, but that would be slow
## and would not work on all platforms (ie would fail on Joe's laptop)
&generateTOC;


print STDOUT "--- Finished ---\n";
exit 0;
##
## end of the slidemaker main program
##############################################################################


##############################################################################
## generate the header of the table of content

sub openOverview 
{
    ## open the file to write to
    open(FOO, ">$_[0].html");

    ## the style sheet used in the table of content is
    $stylelink = "";
    ## here is the standard style sheet
#    $stylelink .= "<link href=\"$cssStandard[$0]\" media =\"all\" rel=\"stylesheet\" type=\"text/css\" title=\"SICS Talk\">";
    $stylelink .= "<link href=\"$cssStandard[$0]\" rel=\"stylesheet\" type=\"text/css\" title=\"SICS Talk\">";
    ## we overload with the user css if it exists
    if ($cssUser[$0]) {
	$stylelink .= "\n<link href=\"$cssUser[$0]\" rel=\"stylesheet\" type=\"text/css\" title=\"W3C Talk\">";
    }

    print FOO <<END;
$doctype
<html lang="$baselang">
<head>
<meta http-equiv="Content-type" content="text/html; charset=$charset">
<title>$talkTitle - $overview</title>
$stylelink
</head>
$body
END

    ## if there's only on logo to put on the toc
    if (length $logoFile2 == 0) {
        print FOO <<END;
<table border="0" width="97%" summary="header logo">
<tr valign="top">
<td align="left"><a href="$logoLink"><img src="$logoFile" align="bottom" border="0" alt="$logoAlt"></a></td>
</tr>
</table>

END
    } elsif (length $logoFile3 == 0) {
     ## the user chose a second logo
        print FOO <<END;
<table border="0" width="97%" summary="header logos">
<tr valign="top">
<td align="left"><a href="$logoLink"><img src="$logoFile" align="bottom" border="0" alt="$logoAlt"></a>
</td>
<td align="right">
<a href="$logoLink2"><img src="$logoFile2" align="bottom" border="0" alt="$logoAlt2"></a></td>
</tr>
</table>

END
    } else {
     ## the user chose a second logo
        print FOO <<END;
<table border="0" width="97%" summary="header logos">
<tr valign="top">
<td align="left"><a href="$logoLink"><img src="$logoFile" align="bottom" border="0" alt="$logoAlt"></a>
</td>
<td align="left"><a href="$logoLink3"><img src="$logoFile3" align="bottom" border="0" alt="$logoAlt3"></a>
</td>
<td align="right">
<a href="$logoLink2"><img src="$logoFile2" align="bottom" border="0" alt="$logoAlt2"></a></td>
</tr>
</table>

END
	}
print FOO <<END;
<h1 align="center" class="slideList">$talkTitle<br>
<i>$author</i></h1>

<h2>$overview</h2>

<ul>
END
}
##
## the beginning of the table of content has been generated and saved
##############################################################################

##############################################################################
## generate the footer of the table of content

sub closeOverview
{
	print FOO <<END;
</ul>

</body>
</html>
END
    close(FOO); 
}
##
## the toc has been completed and saved
##############################################################################

##############################################################################
## add an item in the toc

sub addTitle 
{
    $_[0] =~ s/\r//ig;      # remove the windows CR+LF 
    $_[0] =~ s/<[^>]+>//g;
    if (length $_[0] == 0) {
	return 1;
    }
    # add accesskey for first 9 slides (`1' - `9'), and tabindex for all slides
    if ($_[1] < 10) {
    print FOO <<END;
<li><a accesskey="$_[1]" tabindex="$_[1]" href="bild$_[1]-0.html">$_[0]</a></li>
END
    } else {
    print FOO <<END;
<li><a tabindex="$_[1]" href="bild$_[1]-0.html">$_[0]</a></li>
END
    }
}
##
##############################################################################

##############################################################################
## generate the current slide

sub createSlide 
{

    # parameters are respectively the slide title, its content,
    # its number, the next slide title and the previous slide title
    if (length $_[0] == 0) {
	return 1;
    }

    # work the slide title, the previous and next titles
    $_[0] =~ s/\r//ig;      # remove the windows CR+LF 
    $_[3] =~ s/\r//ig; 
    $_[4] =~ s/\r//ig;
    $title = $_[0];

    # Remove any tags from the prev & next titles
    $_[3] =~ s/<[^>]+>//g;
    $_[4] =~ s/<[^>]+>//g;
    $title =~ s/<[^>]+>//g;

    # Replace double quotes
#   $_[0] =~ s/"/&#34;/g;
    $_[3] =~ s/"/&#34;/g;
    $_[4] =~ s/"/&#34;/g;

    # work the slide content
    $_[1] =~ s/<\/body>//i; # remove if any
    $_[1] =~ s/<\/html>//i; # remove if any

    $status = sprintf "Bild %2d: %s\n", $_[2], $_[0];
    $status =~ s/<[^>]+>//g;
    print STDOUT $status;

    &verify_html($_[1]);    # check the html

    ## we create as many slides as there are css files
    ## Pierre note: it'd be much nicer to have only one slide
    ## which could dynamically load the css file, but ...
    my $cNumber = 0;
    for ($i=0;$i<$nbCssStandard;$i++) {
    $cNumber = $i+1;
    $cNumber = 0  if ($i == $nbCssStandard-1);

    ## write to the slide
    open(SLIDE, ">bild$_[2]-$i.html");

    local($navBar);
    local($toclink);
    local($prevlink);
    local($nextlink);

    ## navigation bar with icons to previous slide, toc and next slide
    $navBar = "<td valign=\"top\" nowrap>\n<div align=\"right\">\n";

    ## the toc link needs to match the slide index
    ## so that the style sheets match between the slides and the toc
    $toclink = "<link rel=\"Contents\" href=\"$overview\.html\" title=\"Contents\">";

    ## initialization of the navigation links
    $nextlink = "";
    $prevlink = "";

    if ($_[2]>1) {
	$prevlink = "<link rel=\"Prev\" href=\"bild".eval($_[2]-1)."-$i.html\" title=\"$prev\">";
#	$navBar .= "<a rel=\"Prev\" href=\"bild".eval($_[2]-1)."-$i.html\" accesskey=\"$prevKey\"><img src=\"$left\" border=\"0\" width=\"32\" height=\"32\" alt=\" f�rra\" title=\"Tillbaka till &#34;$_[3]&#34;\"></a>";
	$navBar .= "|<a rel=\"Prev\" href=\"bild".eval($_[2]-1)."-$i.html\" accesskey=\"$prevKey\">$prev</a>|";
    }

    if ($i == 0) {
   	## we're using the first css file, so no need to number the toc
        $navBar = $navBar."|<a rel=\"Contents\" href=\"$overview\.html\" accesskey=\"$tocKey\">$top</a>|";
#        $navBar = $navBar."<a rel=\"Contents\" href=\"$overview\.html\" accesskey=\"$tocKey\"><img src=\"$top\" border=\"0\" width=\"32\" height=\"32\" alt=\" contents\" title=\"$top\"></a>";
    } else {
        ## change $toclink
        $toclink = "<link rel=\"Contents\" href=\"$overview-$i\.html\" title=\"$top\">";
        ## we're using another css, the toc needs to match
	$navBar = $navBar."|<a rel=\"Contents\" href=\"$overview-$i\.html\" accesskey=\"$tocKey\">$top</a>|";
#	$navBar = $navBar."<a rel=\"Contents\" href=\"$overview-$i\.html\" accesskey=\"$tocKey\"><img src=\"$top\" border=\"0\" width=\"32\" height=\"32\" alt=\" contents\" title=\"$top\"></a>";
    }

    if ($_[2] != $total) {
	$nextlink = "<link rel=\"Next\" href=\"bild".eval($_[2]+1)."-$i.html\" title=\"$next\">";
	$navBar .= "|<a rel=\"Next\" href=\"bild".eval($_[2]+1)."-$i.html\" accesskey=\"$nextKey\">$next</a>|";
#	$navBar .= "<a rel=\"Next\" href=\"bild".eval($_[2]+1)."-$i.html\" accesskey=\"$nextKey\"><img src=\"$right\" border=\"0\" width=\"32\" height=\"32\" alt=\" next\" title=\"On to &#34;$_[4]&#34;\"></a>";
#	$navBar .= "<br><a href=\"bild".eval($_[2])."-$cNumber.html\" accesskey=\"$styleKey\"><img src=\"$barl\" border=\"0\" width=\"96\" height=\"10\" alt=\" change-style\" title=\"change style\"></a></div>";
    } else {
#	$navBar .= "<br><a href=\"bild".eval($_[2])."-$cNumber.html\" accesskey=\"$styleKey\"><img src=\"$bar\" border=\"0\" width=\"32\" height=\"9\" alt=\" change-style\" title=\"change style\"></a></div>";
    }

    $stylelink = "";
    # here is the standard style sheet
#    $stylelink .= "<link href=\"$cssStandard[$i]\" rel=\"stylesheet\" media=\"all\" type=\"text/css\" title=\"W3C Talk\">";
    $stylelink .= "<link href=\"$cssStandard[$i]\" rel=\"stylesheet\" type=\"text/css\" title=\"W3C Talk\">";
    # we overload with the user css if it exists
    if ($cssUser[$i]) {
	$stylelink .= "\n<link href=\"$cssUser[$i]\" rel=\"stylesheet\" type=\"text/css\" title=\"W3C Talk\">";
    }

    print SLIDE <<END;
$doctype
<html lang="$baselang">
<head>
<meta http-equiv="Content-type" content="text/html; charset=$charset">
<title>$talkTitle - bild "$title"</title>
$nextlink
$prevlink
$toclink
$stylelink
</head>
$body
<table cellspacing="0" cellpadding="0" border="0" width="97%" summary="navigation buttons">
<tr valign="top">
END

    if (length $logoFile2 == 0) {
        print SLIDE <<END;
<td align="left"><a href="$logoLink"><img src="$logoFile" border="0" alt="$logoAlt "></a></td>
END

    } else {
        print SLIDE <<END;
<td align="left"><a href="$logoLink"><img src="$logoFile" border="0" alt="$logoAlt"></a>&nbsp;
<a href="$logoLink2"><img src="$logoFile2" border="0" alt="$logoAlt2"></a></td>
END

    }

print SLIDE <<END;
$navBar
</td>
</tr>
</table>

<h1 class="slide">$_[0]</h1>

<hr class="top">

<div class="slidebody">
$_[1]
</div>

<hr class="bottom">

<table cellspacing="0" cellpadding="0" border="0" width="97%" summary="footer">
<tr valign="bottom">
<td><p class="author">$author</p></td>
END

print SLIDE "<td align=\"right\"><p class=\"index\">$_[2] ($total)</p></td>\n";

    print SLIDE <<END;
</tr>
<td>
$footer
</td>
</table>
</body>
</html>
END

    close(SLIDE);
  }
  return 0;
}

##############################################################################
## generate all the toc of contents needed for each css choosen by the user
## the default toc is not numbered so it can be served by a request to '/'
## (ie it remains Overview.html whereas the other toc are called Overview_#.html)

sub generateTOC {

	## read the general toc
	open(FOO, "<$overview.html"); 
	@TOC = <FOO>;
	close(FOO);
	$toc = "@TOC";

	## for each user CSS file
	## starting after the default css
    	for ($css=1;$css<$nbCssStandard;$css++) {

		## create new TOC
		$newTOC = $toc;

		## replace the style link with a new one	
		## <link href="/Talks/Tools/w3ctalk-640.css" rel="stylesheet" type="text/css" title="W3C Talk">
		## we eventually choose the user css file if any
		if (! $cssUser[$css]) {
			$newTOC =~ s/<link href=\"[^\"]*\" rel=\"stylesheet\" type=\"text\/css\" title=\"([^\"]*)\">/<link href=\"$cssStandard[$css]\" rel=\"stylesheet\" type=\"text\/css\" title=\"$1\">/ig;
		} else {
			$newTOC =~ s/<link href=\"[^\"]*\" rel=\"stylesheet\" type=\"text\/css\" title=\"([^\"]*)\">/<link href=\"$cssUser[$css]\" rel=\"stylesheet\" type=\"text\/css\" title=\"$1\">/ig;
		}

		## the links on the toc need also to be modified
		## to link to the correct slides
		$newTOC =~ s/<a accesskey=\"(\d)\" tabindex=\"(\d+)\" href=\"bild(\d+)-\d+\.html\">/<a accesskey=\"$1\" tabindex=\"$2\" href=\"bild$3-$css\.html">/ig;
		$newTOC =~ s/<a tabindex=\"(\d+)\" href=\"bild(\d+)-\d+\.html\">/<a tabindex=\"$1\" href=\"bild$2-$css\.html">/ig;

		## write to new TOC
		$outfile = $overview."-".$css.".html";
		open(OUT, ">$outfile");
		print OUT $newTOC;
		close(OUT)
	}


}

##############################################################################
# check that the html of the slide 
# is correct (ALT tags, ...)
# This procedure produces only warning
sub verify_html {

    if ($_[0] =~ /<img([^>]*)>/im) {
	if (!($1 =~ /ALT=/im)) {
	    print STDOUT "WARNING: <IMG> without ALT\n";
	    print STDOUT "         <IMG$1>\n" ;
	}
    }
}

##############################################################################
# clean the html of the slide
# remove all <div class="comment">blabla</div>
sub clean_html {
    $_[0] =~ s/<div\s+class\s*=\s*(?:comment[\s>]|\"comment\").*?<\/div>//igs;
    return $_[0