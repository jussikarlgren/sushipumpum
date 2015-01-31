#!/bin/bash
for i in 4 5;
do
for j in 01 02 03 04 05 06 07 08 09 10 11 12;
do
touch 199$i$j.xml;
for k in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31;
do
../bin/slaaihopochreknaomtaggar.perl ../tt/199$i$j$k* >>199$i$j.xml &
done;
done;
done;
