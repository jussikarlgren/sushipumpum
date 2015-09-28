use DateTime;
use DateTime::Format::Strptime;

my $parser
    = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
my $sparser
    = DateTime::Format::Strptime->new( pattern => '%Y%m%d' );

my $dt = $parser->parse_datetime('2003-05-04');
my $dts = $sparser->parse_datetime('20030504');
my $dt2 = $parser->parse_datetime('2003-04-28');
my $dts2 = $sparser->parse_datetime('20030428');


$interval
    = DateTime::Duration->new( days => 3);


if ($dts-$interval > $dts2) {print "längre \n";} else {print "kortare\n";}
