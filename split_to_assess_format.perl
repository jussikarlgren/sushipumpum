#!/usr/bin/perl

while(<>) {
    split;
    next if $_[0] eq "";
    next unless $_[3] < 100;
    next if $dok{$_[2].$_[0]};
    $dok{$_[2].$_[0]}++;
    print "$_[0] Q0 0 tt $_[2] $_[3] $_[4] -1 $_[5]\n";
};

#91 Q0 TT9495-950429-218450 0 4.7934217 RUNID 	 XX-avrättningar
#91 Q0 TT9495-940421-164432 1 4.7757783 RUNID 	 XX-amnesty
#91 Q0 TT9495-940202-145016 2 4.6761 RUNID 	 XX-amnesty
#91 Q0 TT9495-950201-205334 3 4.4343166 RUNID 	 XX-amnesty
#91 Q0 TT9495-940114-142193 4 4.333128 RUNID 	 XX-tibet
#91 Q0 TT9495-950531-222718 5 4.3229 RUNID 	 XX-iran-amnesty
#
#   For example, the file topic377 for the TREC topic 377 might contain
#   the the following:
#  377 Q0 0 fb FBIS3-120 55 2.5350 -1 pircs1 120
#  377 Q0 0 fb FBIS3-122 55 2.5350 1 pircs1  122
#  377 Q0 0 fb FBIS3-222 55 2.5350 0 pircs1  222
#
#   A diagram explaining the contents is below:
#   +------------------------------------------- 0 topicno
#   |  +---------------------------------------- 1 queryref
#   |  |  +------------------------------------- 2 iteration
#   |  |  | +----------------------------------- 3 database
#   |  |  | |      +---------------------------- 4 docnostr
#   |  |  | |      |     +---------------------- 5 rank
#   |  |  | |      |     |    +----------------- 6 score
#   |  |  | |      |     |    |     +----------- 7 relevance_code
#   |  |  | |      |     |    |     |   +------- 8 system_code
#   |  |  | |      |     |    |     |   |     +- 9 prise seq. no (if present)
#   |  |  | |      |     |    |     |   |     |
#  377 Q0 0 fb FBIS3-120 55 2.5350 -1 pircs1 120 (unjudged)
#  377 Q0 0 fb FBIS3-122 55 2.5350 1 pircs1  122 (relevant)
#  377 Q0 0 fb FBIS3-222 55 2.5350 0 pircs1  222 (not relevant)

