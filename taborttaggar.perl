#!/usr/bin/perl

while(<>) {
	s/<[^>]*>//g;
	print unless $_ eq "";
}
