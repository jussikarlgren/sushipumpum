#!/usr/local/bin/perl
print STDOUT "Content-Type: text/html\n\n";
print STDOUT "<html><head><title>Ilja Fomitj uppdatering</title></head><body>";
print STDOUT ('<h1>Ilja Fomitj uppdatering</h1>',"\n");


#-----------------------------------------------------------------
$name{neklund} = "Niklas i Norr";
$adress{neklund} = "niklas.eklund\@pol.umu.se";
$name{bisse} = "Bisse";
$adress{bisse} = "jan.christiansson\@ac.com";
$name{herman} = "Herman";
$adress{herman} = "herman114\@hotmail.com";
$name{airland} = "Trader Airland";
$adress{airland} = "erland.karlsson\@gs.com";
$name{tobias} = "Dr. Tobias";
$adress{tobias} = "Tobias.Allander\@infektion.uu.se";
$name{ollek} = "Pan Olle";
$adress{ollek} = "olof.karnell\@energisystem.vattenfall.se";
$name{svante} = "Svante";
$adress{svante} = "svante.andreen\@gs.com";
$name{johana} = "Johan A";
$adress{johana} = "johan.anglemark\@bahnhof.se";
$name{gunnaraa} = "Gunnar &Aring;";
$adress{gunnaraa} = "g.aselius\@telia.com";
$name{gunnarw} = "Gunnar W";
$adress{gunnarw} = "gunnar.warnberg\@foreign.ministry.se";
$name{gunnarmm} = "Gunnar MM";
$adress{gunnarmm} = "gmarn\@unfpa.ebonet.net" 
$name{johanb} = "Johan i Beijing";
$adress{johanb} = "aboda\@public3.bta.net.cn";
$name{hgf} = "HGF";
$adress{hgf} = "henrik.g.forsstrom\@swipnet.se";
$name{jonas} = "Jonas i Singapore";
$adress{jonas} = "jonasg\@singnet.com.sg";
$name{fredi} = "Fredi";
$adress{fredi} = "fredi.hedenberg\@apis.se";
$name{rickard} = "Rickard";
$adress{rickard} = "rickard.hedlund\@moregroup.se";
$name{jake} = "Jake";
$adress{jake} = "linguaweb\@swipnet.se"
$name{engsner} = "Henrik";
$adress{engsner} = "henrik.engsner\@swipnet.se";
$name{hgf} = "HGF";
$adress{hgf} = "henrik.g.forsstrom\@swipnet.se";
$name{jonas} = "Jonas i Singapore";
$adress{jonas} = "jonasg\@singnet.com.sg";
$name{fredi} = "Fredi";
$adress{fredi} = "fredi.hedenberg\@apis.se";
$name{rickard} = "Rickard";
$adress{rickard} = "rickard.hedlund\@moregroup.se";
$name{jake} = "Jake";
$adress{jake} = "linguaweb\@swipnet.se"
$name{jussi} = "Jussi";
$adress{jussi} = "jussi\@sics.se";
$name{lankan} = "Lankan";
$adress{lankan} = "Hakan.Landqvist\@nordiska.uu.se";
$name{kristian} = "Kristian";
$adress{kristian} = "kskanberg\@konj.se";
#$name{patrik} = "Patrik";
$name{petter} = "Petter";
$adress{petter} = "pron\@ent.ks.se";
$name{schubert} = "Sjubban";
$adress{schubert} = "ulf.schuberth\@era.ericsson.se";
$name{fredrik} = "Fredrik";
$adress{fredrik} = "fredrik.stromholm\@gs.se";
$name{olle} = "Olle S";
$adress{olle} = "Olof_Stalnacke\@mckinsey.com";
$name{johannes} = "Johannes";
$adress{johannes} = "Johannes.Aman\@dn.se";
$name{per} = "Per";
$adress{per} = "frykholms\@swipnet.se";
$name{ville} = "Wilhelm";
$adress{ville} = "wilung\@sto.foa.se";
$name{dake} = "Dake";
$adress{dake} = "tomas.danestad\@finance.ministry.se";
#-----------------------------------------------------------------




if ($ENV{'REQUEST_METHOD'} eq 'POST') {
	$laengd = $ENV{'CONTENT_LENGTH'};
if (read(STDIN, $data, $laengd) != $laengd) { die("Fel i POST-inlaesning\n");};
};





foreach (split '&', $data) 
	{ ($name, $val) = split ('='); 
           if ($val) {$vaerde{$name} = "CHECKED"};
	}

print STDOUT "<hr>";
print STDOUT "<h2>P&aring;slagna:</h2>\n";
print STDOUT "<ul>\n";
foreach (sort keys %vaerde) {
print STDOUT "<li> $name{$_}\n";
}
print STDOUT "</ul>\n";

open(PFILE,"/home/jussi/public_html/tolkmaster.txt");
while(<PFILE>) {if (/NAME=(\w*) CHECKED/) {$fd{$1}='CHECKED';};};
close(PFILE);

open(TFILE,">/home/jussi/public_html/tolkmaster.txt");
print TFILE "<DL>\n";
foreach (sort keys %name) {
   print TFILE "<dt><INPUT TYPE=checkbox NAME=$_ $vaerde{$_}> $name{$_}\n";
   };
print TFILE "</DL>\n";
close(TFILE);

open(AFILE,">/home/jussi/Aliases/tolklista");
foreach (keys %vaerde) {
	print AFILE "$adress{$_}\n";
};
close(AFILE);

open(OFILE,">/usr/tmp/jtmp");
print OFILE "En anvaendare paa $ENV{'REMOTE_HOST'} har aendrat ilja.fomitj:\n";
foreach (sort keys %name)
{ if ($fd{$_} ne $vaerde{$_}) {print OFILE "$_: ",$fd{$_}?$fd{$_}:OFFLINE," -> ",$vaerde{$_}?$vaerde{$_}:OFFLINE,"\n";};};
close(OFILE);

system ("mail  jussi < /usr/tmp/jtmp" );


print STDOUT "<hr>\n";
print STDOUT "Nu ska det vara fixat. ";
print STDOUT "Tillbaka till formul&auml;ret: <a href=http://www.sics.se/~jussi/iljafomitj.shtml>klick!</a> ";
print STDOUT "<hr>\n";

print STDOUT "</body></html>";








