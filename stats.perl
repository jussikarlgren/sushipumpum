#!/usr/local/bin/perl
print "asdfad";
$debug = 1;
$docid = $ARGV[0];
$/ = "/n/n";    
$* = 1;
%lexcat = (
#4        
"PLACEADV",
"aboard",PLACEADV, "above",PLACEADV, "abroad",PLACEADV, "across",PLACEADV, "ahead",PLACEADV, "alongside",PLACEADV, "around",PLACEADV, "ashore",PLACEADV, "astern",PLACEADV, "away",PLACEADV, "behind",PLACEADV, "below",PLACEADV, "beneath",PLACEADV, "beside",PLACEADV, "downhill",PLACEADV, "downstairs",PLACEADV, "sownstream",PLACEADV, "east",PLACEADV, "far",PLACEADV, "hereabouts",PLACEADV, "indoors",PLACEADV, "inland",PLACEADV, "inshore",PLACEADV, "inside",PLACEADV, "locally",PLACEADV, "near",PLACEADV, "nearby",PLACEADV, "norht",PLACEADV, "nowhere",PLACEADV, "outdoors",PLACEADV, "outside",PLACEADV, "overboard",PLACEADV, "overland",PLACEADV, "overseas",PLACEADV, "south",PLACEADV, "underfoot",PLACEADV, "underground",PLACEADV, "underneath",PLACEADV, "uphill",PLACEADV, "upstairs",PLACEADV, "upstream",PLACEADV, "west",PLACEADV,
#5 "TIMEADV",
"afterwards",TIMEADV, "again",TIMEADV, "earlier",TIMEADV, "early",TIMEADV, "eventually",TIMEADV, "formerly",TIMEADV, "immediately",TIMEADV, "initially",TIMEADV, "instantly",TIMEADV, "late",TIMEADV, "lately",TIMEADV, "later",TIMEADV, "momentarily",TIMEADV, "now",TIMEADV, "nowadays",TIMEADV, "once",TIMEADV, "originally",TIMEADV, "presently",TIMEADV, "previously",TIMEADV, "recently",TIMEADV, "shortly",TIMEADV, "simultaneously",TIMEADV, "soon",TIMEADV, "subsequently",TIMEADV, "today",TIMEADV, "tomorrow",TIMEADV, "tonight",TIMEADV, "yesterday", TIMEADV,
#6
"i",PRON1,"me",PRON1,"we",PRON1,"us",PRON1,"myself",PRON1,"ourself",PRON1,"ourselves",PRON1,"my",PRON1,"mine",PRON1,"our",PRON1,"ours",PRON1,
#7
"you",PRON2,"yours",PRON2,"yourself",PRON2,"yourselves",PRON2,
#8
"he",PRON3,"she",PRON3,"him",PRON3,"her",PRON3,"they",PRON3,"them",PRON3,"himself",PRON3,"herself",PRON3,"themself",PRON3,"themselves",PRON3,"his",PRON3,"hers",PRON3,"their",PRON3,"theirs",PRON3,
#9
"it",IT,"its",IT,"itself",
#10
"that",DEMPRON,"those",DEMPRON,"this",DEMPRON,"these",DEMPRON,
#11
"anybody",INDEF,"nothing",INDEF,"someone",INDEF, "anyone", INDEF, "anything", INDEF, "everybody", INDEF, "everyone", INDEF, "everything", INDEF, "nobody", INDEF, "someone", INDEF, "something", INDEF, "none", INDEF, "nowhere", INDEF,
#35 causative subordinators
"because",BECAUSE,
#36 concessive subordinators
"although",CONCESSIVE,"though",CONCESSIVE,
#37 conditional subordinators
"if",CONDITION,"unless",CONDITION,
#38 other adverbial subordinators
"since",ADVSUB,"while",ADVSUB,"whilst",ADVSUB,"whereupon",ADVSUB,"whereas",ADVSUB,"whereby",ADVSUB,"insasmuch as",ADVSUB,"forasmuch as",ADVSUB,"insofar as",ADVSUB,"inasmuch as",ADVSUB,"as long as",ADVSUB,"as soon as",ADVSUB,
# such that so that + not an np 
#46
"almost", DOWNTONERS,"barely", DOWNTONERS,"hardly", DOWNTONERS,"merely", DOWNTONERS,"mildly", DOWNTONERS,"nearly", DOWNTONERS,"only", DOWNTONERS,"partially", DOWNTONERS,"partly", DOWNTONERS,"practically", DOWNTONERS,"scarcely", DOWNTONERS,"slightly", DOWNTONERS,"somewhat", DOWNTONERS,
#48
"absolutely", AMPLIFIERS, "altogether", AMPLIFIERS, "completely", AMPLIFIERS, "enormously", AMPLIFIERS, "entirely", AMPLIFIERS, "extremely", AMPLIFIERS, "fully", AMPLIFIERS, "greatly", AMPLIFIERS, "highly", AMPLIFIERS, "intensely", AMPLIFIERS, "perfectly", AMPLIFIERS, "strongly", AMPLIFIERS, "thoroughly", AMPLIFIERS, "totally", AMPLIFIERS, "utterly", AMPLIFIERS, "very", AMPLIFIERS,
#49
"just",EMPHATICS,"really",EMPHATICS,"most",EMPHATICS,"more",EMPHATICS,
#and more!
#50 clause boundary!+ #well#now#anyway#anyhow#anyways
#52 (incl contractions handled by morph component.)  
"can",POSSMOD,"may",POSSMOD,"might",POSSMOD,"could",POSSMOD,
#53 (incl contractions handled by morph component.)
"ought",NECMOD,"should",NECMOD,"must",NECMOD,
#54 (incl contractions handled by morph component.)
"will",PREDMOD,"would",PREDMOD,"shall",PREDMOD,
#55                  
"acknowledge",PUBLICVERB,"admit",PUBLICVERB,"agree",PUBLICVERB,"assert",PUBLICVERB,"claim",PUBLICVERB,"complain",PUBLICVERB,"declare",PUBLICVERB,"deny",PUBLICVERB,"explain",PUBLICVERB,"hint",PUBLICVERB,"insist",PUBLICVERB,"mention",PUBLICVERB,"proclaim",PUBLICVERB,"promise",PUBLICVERB,"protest",PUBLICVERB,"remark",PUBLICVERB,"reply",PUBLICVERB,"report",PUBLICVERB,"say",PUBLICVERB,"suggest",PUBLICVERB,"swear",PUBLICVERB,"write",PUBLICVERB,
#56                  
"anticipate",PRIVATEVERB,"assume",PRIVATEVERB,"believe",PRIVATEVERB,"conclude",PRIVATEVERB,"decide",PRIVATEVERB,"demonstrate",PRIVATEVERB,"determine",PRIVATEVERB,"discover",PRIVATEVERB,"doubt",PRIVATEVERB,"estimate",PRIVATEVERB,"fear",PRIVATEVERB,"feel",PRIVATEVERB,"find",PRIVATEVERB,"forget",PRIVATEVERB,"guess",PRIVATEVERB,"hear",PRIVATEVERB,"hope",PRIVATEVERB,"imagine",PRIVATEVERB,"imply",PRIVATEVERB,"indicate",PRIVATEVERB,"infer",PRIVATEVERB,"know",PRIVATEVERB,"learn",PRIVATEVERB,"mean",PRIVATEVERB,"notice",PRIVATEVERB,"prove",PRIVATEVERB,"realize",PRIVATEVERB,"realise",PRIVATEVERB,"recognize",PRIVATEVERB,"recognise",PRIVATEVERB,"remember",PRIVATEVERB,"reveal",PRIVATEVERB,"see",PRIVATEVERB,"show",PRIVATEVERB,"suppose",PRIVATEVERB,"think",PRIVATEVERB,"understand",PRIVATEVERB,
#57                  
"agree",SUASIVEVERB,"arrange",SUASIVEVERB,"ask",SUASIVEVERB,"beg",SUASIVEVERB,"command",SUASIVEVERB,"decide",SUASIVEVERB,"demand",SUASIVEVERB,"grant",SUASIVEVERB,"insist",SUASIVEVERB,"instruct",SUASIVEVERB,"ordain",SUASIVEVERB,"pledge",SUASIVEVERB,"pronounce",SUASIVEVERB,"propose",SUASIVEVERB,"recommend",SUASIVEVERB,"request",SUASIVEVERB,"stipulate",SUASIVEVERB,"suggest",SUASIVEVERB,"urge",SUASIVEVERB,
"agreed",SUASIVEVERB,"arranged",SUASIVEVERB,"asked",SUASIVEVERB,"begged",SUASIVEVERB,"commanded",SUASIVEVERB,"decided",SUASIVEVERB,"demanded",SUASIVEVERB,"granted",SUASIVEVERB,"insisted",SUASIVEVERB,"instructed",SUASIVEVERB,"ordained",SUASIVEVERB,"pledged",SUASIVEVERB,"pronounced",SUASIVEVERB,"proposed",SUASIVEVERB,"recommended",SUASIVEVERB,"requested",SUASIVEVERB,"stipulated",SUASIVEVERB,"suggested",SUASIVEVERB,"urged",SUASIVEVERB,
"agreeing",SUASIVEVERB,"arranging",SUASIVEVERB,"asking",SUASIVEVERB,"begging",SUASIVEVERB,"commanding",SUASIVEVERB,"deciding",SUASIVEVERB,"demanding",SUASIVEVERB,"granting",SUASIVEVERB,"insisting",SUASIVEVERB,"instructing",SUASIVEVERB,"ordaining",SUASIVEVERB,"pledging",SUASIVEVERB,"pronouncing",SUASIVEVERB,"proposing",SUASIVEVERB,"recommending",SUASIVEVERB,"requesting",SUASIVEVERB,"stipulating",SUASIVEVERB,"suggesting",SUASIVEVERB,"urging",SUASIVEVERB,
"agrees",SUASIVEVERB,"arranges",SUASIVEVERB,"asks",SUASIVEVERB,"begs",SUASIVEVERB,"commands",SUASIVEVERB,"decides",SUASIVEVERB,"demands",SUASIVEVERB,"grants",SUASIVEVERB,"insists",SUASIVEVERB,"instructs",SUASIVEVERB,"ordains",SUASIVEVERB,"pledges",SUASIVEVERB,"pronounces",SUASIVEVERB,"proposes",SUASIVEVERB,"recommends",SUASIVEVERB,"requests",SUASIVEVERB,"stipulates",SUASIVEVERB,"suggests",SUASIVEVERB,"urges",SUASIVEVERB,
#58                  
"seem",'S/A', "appear",'S/A',
#PREPS
"aboard", PREP, "about", PREP, "above", PREP, "across", PREP, "afore", PREP, "after", PREP, "against", PREP, "along", PREP, "alongside", PREP, "amid", PREP, "amidst", PREP, "among", PREP, "amongst", PREP, "around", PREP, "aside", PREP, "astride", PREP, "at", PREP, "atop", PREP, "barring", PREP, "before", PREP, "behind", PREP, "below", PREP, "beneath", PREP, "beside", PREP, "besides", PREP, "between", PREP, "betwixt", PREP, "beyond", PREP, "but", PREP, "by", PREP, "concerning", PREP, "despite", PREP, "down", PREP, "during", PREP, "except", PREP, "excluding", PREP, "failing", PREP, "following", PREP, "for", PREP, "from", PREP, "given", PREP, "in", PREP, "including", PREP, "inside", PREP, "into", PREP, "like", PREP, "near", PREP, "next", PREP, "notwithstanding", PREP, "of", PREP, "off", PREP, "on", PREP, "onto", PREP, "opposite", PREP, "out", PREP, "outside", PREP, "over", PREP, "pace", PREP, "past", PREP, "per", PREP, "plus", PREP, "pro", PREP, "qua", PREP, "regarding", PREP, "round", PREP, "sans", PREP, "save", PREP, "since", PREP, "than", PREP, "through", PREP, "thru", PREP, "throughout", PREP, "till", PREP, "to", PREP, "toward", PREP, "towards", PREP, "under", PREP, "underneath", PREP, "unlike", PREP, "until", PREP, "up", PREP, "upon", PREP, "via", PREP, "with", PREP, "within", PREP, "without", PREP, 
#66 (cf. morph component)
"nor", SYNTHNEG, "neither", SYNTHNEG
);

open(DATA,"<biber.data");
while (<DATA>) {
print STDERR "help im stuck!\n";
    split;
    $mean{$_[0]} = $_[1];
    $stdev{$_[0]} = $_[2];
};
close(DATA);
#==============================================================================
$lineid=0;
while (<>) {
#==============================================================================
# statistics initialization
$typecount = 0;
$wordcount = 0;
$sentcount = 0;
$charcount = 0;
$captokcount = 0;
$lw = 0;
%mendenhall = ();
%typetab = ();
%bibertab = (
WPS, 0,
DIGS, 0,
LW, 0,
CTT, 0,
PAST, 0,
PERF, 0,
PRES, 0,
PLACEADV, 0,
TIMEADV, 0,
PRON1, 0,
PRON2, 0,
PRON3, 0,
IT, 0,
DEMPRON, 0,
INDEF, 0,
DOMAINV, 0,
WHQ, 0,
NOMINALIZATIONS, 0,
GERUNDS, 0,
NOUNS, 0,
PASSNOBY, 0,
PASSWBY, 0,
BEMAINV, 0,
THEREIS, 0,
THATVCOMPL, 0,
THATADJCOMPL, 0,
WHCL, 0,
INF, 0,
PRESPCL, 0,
PASTPCL, 0,
PASTPWHIZDEL, 0,
PRESPWHIZDEL, 0,
THATSUBJ, 0,
THATOBJ, 0,
WHSUBJ, 0,
WHOBJ, 0,
PIEPREL, 0,
SENTREL, 0,
BECAUSE, 0,
CONCESSIVE, 0,
CONDITION, 0,
ADVSUB, 0,
PP, 0,
ATTRADJ, 0,
PREDADJ, 0,
ADVERBS, 0,
TT, 0,
CPW, 0,
CONJUNCTS, 0,
DOWNTONERS, 0,
HEDGES, 0,
AMPLIFIERS, 0,
EMPHATICS, 0,
DISCPART, 0,
DEM, 0,
POSSMOD, 0,
NECMOD, 0,
PREDMOD, 0,
PUBLICVERB, 0,
PRIVATEVERB, 0,
SUASIVEVERB, 0,
'S/A', 0,
CONTRACTIONS, 0,
SUBTHATDEL, 0,
STRANDPREP, 0,
SPLITINF, 0,
SPLITAUX, 0,
PHRASECOORD, 0,
CLAUSECOORD, 0,
SYNTHNEG, 0,
ANALNEG,0);
 #preprocessor
    s/\<[^\>]*\>//g ;   # remove tags
    s/-\n/-/g;          # join hyphenated words at line breaks
    s/[\}\{\[\],)(\"]/\ /g;             # remove punctuation (lesser)
    s/\ \-\ /\ /g;              # remove dashes
    s/\ \-\-\ /\ /g;            # remove double dashes
    $_ =~ s/[;:!\?]/\ ;\ /g;                # remove punctuation (sentence break)
    $_ =~ s/(\D)\.(\D)/$1\ ;$2/g;   # remove punctuation (period - nondec)
    @text = split;
#word by word computation
    foreach $token (@text) { 
        if ($token =~ /^[A-ZÅÄÖ]\w+/) {$cap = 1; $captokcount++;};
	tr/A-Z/a-z/;               
	if ($token eq ";") {
	    $sentcount++; 
	} else {
	    if ($token*1 != 0) {$bibertab{DIGS}++;};
	    $wordcount++;
# lexical biber scores
	    $bibertab{$lexcat{$token}}++ if $lexcat{$token};
	    if (length($token) > 7) {$lw++};
	    $charcount += length($token);
	    $mendenhall{length($token)}++;
	}; # if $_ is token, interpunction, or analysis. or "hupp?"
    } # foreach @_
    $lineid++;
#==============================================================================
#        if ($pos eq "V") {
#           if ($morph =~ /(PAST)/ || $morph =~ /(PRES)/) { # 1:"PAST" 3:"PRES"
#                $bibertab{$1}++;
#            };
#           if ($base eq "do" && $syntax =~ MAINV) { # 12 pro-verb do
#                $bibertab{DOMAINV}++;
#            };
#------------------------------------------------------------------------------ 
#        } elsif ($pos eq "PRON") {
#            if ($derivation =~ /Rel/) { # 29, 30, 31, 32
#               if ($syntax =~ /SUBJ/) {
#                  if ($base eq that) {
#                     $bibertab{THATSUBJ}++;
#                  } elsif ($derivation =~ /WH/) {
#                     $bibertab{WHSUBJ}++;
#                  };
#               } elsif ($syntax =~ /OBJ/) {
#                  if ($base eq that) {
#                     $bibertab{THATOBJ}++;
#                  } elsif ($derivation =~ /WH/) {
#                     $bibertab{WHOBJ}++;
#                  };
#              };
#              if ($syntax =~ /\<P/) { #33
#                     $bibertab{PIEPREL}++;
#              };
#            };
#------------------------------------------------------------------------------
#        } elsif ($pos eq "N") {
if ($token =~ /tion$/ || $token =~ /ness$/ || $token =~ /ment$/ || $token =~ /ity$/ ) { # 14 nominalizations
    $bibertab{NOMINALIZATIONS}++;
}
if ($token =~ /ly$/) {
    $bibertab{ADVERB}++;
}
#            } else { # 16  nouns                                               
#                $bibertab{NOUNS}++;
#
#------------------------------------------------------------------------------
#        } elsif ($pos =~ /INFMARK/) {# 24 number of infinitives                
#                $bibertab{INF}++;
#------------------------------------------------------------------------------
#        } elsif ($pos eq "PREP") {
#            if ($syntax =~ /\<NOM/) { # 39 number of pps                       
#------------------------------------------------------------------------------
#        } elsif ($pos eq "A") {
#            if ($syntax =~ /PCOMPL/) { # 41 predicative adjectives             
#                $bibertab{PREDADJ}++;
#            } else { # 40 attributive adjectives                               
#                $bibertab{ATTRADJ}++;
#            };
#------------------------------------------------------------------------------
#        } elsif ($pos eq "ADV") {#42:"ADVERBS",                                
#            $bibertab{ADVERBS}++;
#-ly PREP
#------------------------------------------------------------------------------
#        } elsif ($pos eq "DET") {
#            if ($morph =~ /DEM/ && $syntax =~ /DN\>/) { # 51:"DEM"             
#                $bibertab{DEM}++;
#            };
#            if ($morph =~ /NEG/) {
#                $bibertab{SYNTHNEG}++;  # 66:"SYNTHNEG" (cf. lexical component)
#            };
##------------------------------------------------------------------------------
#        } elsif ($pos eq "NEG-PART") { # 67:"ANALNEG"                          
#            $bibertab{ANALNEG}++;
#        }; # if pos elsif pos                                                  
##------------------------------------------------------------------------------
#       if ($morph =~ /WH/) { # 13:"WHQ"                                       
#           $bibertab{WHQ}++;                                                  
#       };
           
#------------------------------------------------------------------------------
# 59:"CONTRACTIONS" ( excludes "The cook's gone rotten." See biber 1988 for  better rule. )                         
#        if ($token =~ /\'/ && $pos ne "N") {$bibertab{CONTRACTIONS}++;};
#------------------------------------------------------------------------------# lexical biber scores               
#        $bibertab{$lexcat{$base}}++ if $lexcat{$base};
#    } else {
#        chop; $token = "hupp?";
#    }; # if $_ is token, interpunction, or analysis. or "hupp?"                
#print "$token $base pos:$pos morph:$morph syntax:$syntax der:$derivation\n" if $debug;                             
} # while <>
         
#==============================================================================
# calculate some final scores                                                  
#0:CTT
               
foreach (keys %captypetab) {$captypecount++;};
if ($captokcount) {$bibertab{CTT} = $captypecount/$captokcount;} else {$bibertab{CTT} = 0;};
#43: TT
              
foreach (keys %typetab) {$typecount++;};
if ($wordcount) {
    $bibertab{TT} = $typecount;
#0:LW
                
    $biber{LW} = $lw;
#44: CPW
             
    $bibertab{CPW} = $charcount;
#0:DIGS
              
    $bibertab{DIGS} = $digcount;
#0:WPS
               
    if ($sentcount) {$bibertab{WPS} = $wordcount/$sentcount;} else {$bibertab{WPS} = $wordcount;};
};
#==============================================================================
if ($debug) {
    print "$docid $lineid $wordcount ";
    foreach (sort keys %bibertab) {print "$_ $bibertab{$_} "};
print "\n";};
#==============================================================================
# normalize scores
foreach (sort byval keys %bibertab) {
    if ($_ eq "CTT") {
        $bibertabf{$_} = $bibertab{$_}
    } else {
        $bibertabf{$_} = ($bibertab{$_}*1000/$wordcount);
    };

    if ($stdev{$_}) {$bibertabn{$_} = ($bibertabf{$_}-$mean{$_})/$stdev{$_};}
    else {$bibertabn{$_} = $bibertabf{$_}};
};
#==============================================================================
%biber1 = (PRIVATE, 1,  SUBTHATDEL, 1,  CONTRACTIONS, 1,  PRES, 1,  PRON2, 1,  DOMAINV, 1,  ANALNEG, 1,  DEMPRON, 1,  EMPHATICS, 1,  PRON1, 1,  IT, 1,  BEMAINV, 1,  BECAUSE, 1,  DISCPART, 1,  INDEF, 1,  HEDGES, 1,  AMPLIFIERS, 1,  SENTREL, 1,  WHQ, 1,  POSSMOD, 1,  CLAUSECOORD, 1,  WHCL, 1,  STRANDPREP, 1, NOUNS, -1,  CPW, -1,  PPS, -1,  TT, -1,  ATTRADJ, -1);
%biber2 = (PAST, 1,  PRON3, 1,  PERF, 1,  PUBLIC, 1,  SYNTHNEG, 1,  PRESPCL);
%biber3 = (WHOBJ, 1,  PIEPREL, 1,  WHSUBJ, 1,  PHRASECOORD, 1,  NOMINALIZATIONS, 1, TIMEADV, -1,  PLACEADV, -1,  ADVERBS, -1);
%biber4 = (INF, 1,  PREDMOD, 1,  SUASIVE, 1,  CONDITION, 1,  NECMOD, 1,  SPLITAUX, 1);
%biber5 = (CONJUNCTS, 1,  PASSNOBY, 1,  PASTPCL, 1,  PASSWBY, 1,  PASTPWHIZDEL, 1,  ADVSUB, 1);
%biber6 = (THATVCOMPL, 1,  DEM, 1,  THATOBJ, 1,  THATADJCOMPL, 1);
%biber7 = ('S/A', 1);

foreach (keys %biber1) {
    $d1 += $bibertabn{$_}*$biber1{$_};
};
foreach (keys %biber2) {
    $d2 += $bibertabn{$_}*$biber2{$_};
};
foreach (keys %biber3) {
    $d3 += $bibertabn{$_}*$biber3{$_};
};
foreach (keys %biber4) {
    $d4 += $bibertabn{$_}*$biber4{$_};
};
foreach (keys %biber5) {
    $d5 += $bibertabn{$_}*$biber5{$_};
};
foreach (keys %biber6) {
    $d6 += $bibertabn{$_}*$biber6{$_};
};
foreach (keys %biber7) {
    $d7 += $bibertabn{$_}*$biber7{$_};
};

print "$docid $lineid Involved: $d1 Narrative: $d2 Explicit: $d3 Persuasion: $d4 Abstract: $d5 Elaboration: $d6\n" if $debug;     
print "$docid $lineid $d1 $d2 $d3 $d4 $d5 $d6\n" unless $debug;
print " S/A: $d7 words=",$wordcount," types=$typecount lw=", $b, " dig=$digits wps=",$wps," ct/t=$ctt\n" if $debug;
exit;
#==============================================================================
# sorting subroutine
sub byval { $bibertab{$a} <=> $bibertab{$b}; };
#==============================================================================


