$i = 0;
while (<>) {
    chomp;
    if (/<eDok>/) {
	$i++;
	if ($fields{diagnos} =~ /f([\ \.\-])*32/g) {$fields{diagnos} = "f32";}
	if ($fields{diagnos} =~ /s([\ \.])*82/g) {$fields{diagnos} = "s82";}
	for $field (sort keys %fields) {
	    print "$i\t$field\t$fields{$field}\n";
	}
	undef %fields;
    }
    if (/<SJP:diagnosKod>(.+)<\/SJP:diagnosKod>/) {$field = diagnos; $fields{$field} = lc($1); undef $field; next; }
    if (/<SJP:diagnosKod>(.+)$/) {$field = diagnos; $fields{$field} = lc($1); undef $field; next; }
    if (/<SJP:diagnosKod>$/) {$field = diagnos;}
    if ($field eq diagnos) {$diagnos = $_;}
    if (/<\/SJP:diagnosKod>/) {$fields{$field} = $diagnos; undef $field; undef $diagnos; next; }
    if (/<pnr>(\d+-\d\d(\d)\d)<\/pnr>/) {$field = genus; if ($2 % 2 == 0) { $fields{$field} = "f";  } else { $fields{$field} = "m";}
				       $fields{diagnos} .= " $1";
				       undef $field; next;}
    if (/<SJP:rekommendationer>/) {$field="rekommendation";}
#    if (/<SJP:beskrivning>/){$field = "beskrivning";}
    if (/<SJP:prognos>/){$field = "prognos";}
    if (/<SJP:mojliggorAnnatFardsattAtergangTillArbete>/){$field = "fardsatt";}
    if (/<SJP:arbetsformagaNedsattLangreTid>/){$field = "langtid";}
    if (/<SJP:objektivaUndersokningsFynd>/) {$field = "undersokning";}
    if (/heltNedsatt>/) {$datum = 1;}
    if ($datum) {
	if (/<SJP:fromDatum>([\d\-]+)<\/SJP:fromDatum>/) {$fields{"datum"} = $1."-".$fields{"datum"};}
	if (/<SJP:tomDatum>([\d\-]+)<\/SJP:tomDatum>/) {$fields{"datum"} = $fields{"datum"}."-".$1;}
    }
    if (/ftenNedsatt>/) {$a50datum = 1;}
    if ($a50datum) {
	if (/<SJP:fromDatum>([\d\-]+)<\/SJP:fromDatum>/) {$fields{"50datum"} = $1."-".$fields{"50datum"};}
 	  if (/<SJP:tomdatum>([\d\-]+)<\/SJP:tomDatum>/) {$fields{"50datum"} = $fields{"50datum"}."-".$1;}
    }
    if (/fjar.*Nedsatt>/) {$a25datum = 1;}
    if ($a25datum) {
	if (/<SJP:fromDatum>([\d\-]+)<\/SJP:fromDatum>/) {$fields{"25datum"} = $1."-".$fields{"25datum"};}
	if (/<SJP:tomDatum>([\d\-]+)<\/SJP:tomDatum>/) {$fields{"25datum"} = $fields{"25datum"}."-".$1;}
    }
    if (/Fjar.*Nedsatt>/) {$a75datum = 1;}
    if ($a75datum) {
	if (/<SJP:fromDatum>([\d\-]+)<\/SJP:fromDatum>/) {$fields{"75datum"} = $1."-".$fields{"75datum"};}
	if (/<SJP:tomDatum>([\d\-]+)<\/SJP:tomDatum>/) {$fields{"75datum"} = $fields{"75datum"}."-".$1;}
    }
    if (/<SJP:atgarder>/) {$field="atgarder";}
    if ($field) {
	$txt = $_;
	if (/<SJP:nej\/>/) {$fields{$field} .= "NEJ";}
	if (/<SJP:ja\/>/) {$fields{$field} .= "JA";}
	$txt =~ s/<[^>]+>//g;
	$txt =~ tr/A-Z/a-z/;
	$txt =~ s/[\.,;:\?\!]/\ /g;
	$fields{$field} .= $txt;
    }
    if (/<\/SJP:atgarder>/) {undef $field;}
    if (/<\/SJP:rekommendationer>/) {undef $field;}
#    if (/<\/SJP:beskrivning>/){undef $field;}
    if (/<\/SJP:prognos>/){undef $field;}
    if (/<\/SJP:mojliggorAnnatFardsattAtergangTillArbete>/){undef $field;}
    if (/<\/SJP:arbetsformagaNedsattLangreTid>/){undef $field;}
    if (/<\/SJP:objektivaUndersokningsFynd>/) {undef $field;}
    if (/<\/.*Nedsatt>/) {undef $datum;}
    if (/<\/.*Fjar.*Nedsatt>/) {undef $a75datum;}
    if (/<\/.*fjar.*Nedsatt>/) {undef $a25datum;}
    if (/<\/.*ftenNedsatt>/) {undef $a50datum;}

}
$i++;
for $field (sort keys %fields) {
    print "$i\t$field\t$fields{$field}\n";
}
