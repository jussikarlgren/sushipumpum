#!/usr/bin/perl
#<Session SessionId="{84897E31-A7BA-4722-8D6F-929CDBCAC6A7}" SessionName="Session0.wav" RecordingId="Rec01" NetId="79" UserId="1851871363" ChannelId="73" CoSoundId="0" CoSoundVol="0" StartTimeHi="29763343" StartTimeLo="-726472824" StopTimeHi="29763343" StopTimeLo="-658191574"/>

while(<>) {
    ($filename,$sessionid,$netid,$hi,$lo) = m/SessionName=\"(Session([\d]+)\.wav)\".*NetId=\"(\d\d)\".*StartTimeHi=\"(\d+)\" StartTimeLo=\"([\-\d]+)\"/;

    if ($sessionid < 10) {$sessionid = "000".$sessionid;}
    elsif ($sessionid < 100) {$sessionid = "00".$sessionid;}
    elsif ($sessionid < 1000) {$sessionid = "0".$sessionid;}

print "cp $filename $netid/Session$sessionid.$netid.$hi.$lo.wav\n";
  }
