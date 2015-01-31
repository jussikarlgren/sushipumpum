#!/bin/bash
for i in 4 5;
do
j="01";
for j in 01 02 03 04 05 06 07 08 09 10 11 12; do
k="01";
for k in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
m=1;
n=000$m;
source="/data/corpora/de/split/SDA.9$i$j$k.$n.html"
target="/data/corpora/de/split/SDA.9$i$j$k.$n.html.fix"
while test -a $source;  do
#echo $source;
# cstlemma filen
/data/bin/SDA_fixa_filerna_liten_bugg.perl < $source > $target
mv $target $source;
(( m++ ));
# omformulera $n med ny siffra 
#echo $m;
if [ $m -lt 10 ]; then n=000$m; elif [ $m -lt 100 ]; then n=00$m; elif [ $m -lt  1000 ]; then n=0$m; else n=9999;
fi
source="/data/corpora/de/split/SDA.9$i$j$k.$n.html"
target="/data/corpora/de/split/SDA.9$i$j$k.$n.html.fix"
#echo $m;
#echo $target;
done; # while test
done; # for k
done; # for j
done; # for i
