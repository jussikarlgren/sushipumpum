#!/bin/bash
#for i in 4 5; do
tdir="lemma";
i="4";
j="01";
for j in 01 02 03 04 05 06 07 08 09 10 11 12; do
k="01";
for k in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
m=1;
n=000$m;
source="/src/harvahammas/corpora/de/split/SDA.9$i$j$k.$n.html"
target="/src/harvahammas/corpora/de/$tdir/SDA.lemma.9$i$j$k.$n.html"
#echo $source;
while test -a $source.bz2;  do
#echo $source;
# cstlemma filen
bunzip2 $source.bz2
/src/harvahammas/bin/SDA_taborttaggar.perl $source > temp
echo "<html>" > $target
echo "<doc>" >> $target
echo "<meta name=\"dc.identifier\" content=\"sda.9$i$j$k.$n\">" >> $target
/home/jussi/Tvarsok/cstlemma -L -p+ -q- -U -H0 -B'$w' -c '$B$s' -f /home/jussi/Tvarsok/flexrulesC1  -t- < temp >> $target
echo "" >> $target
echo "</doc>" >> $target
echo "</html>" >> $target
bzip2 $source;
#bzip2 $target;
(( m++ ));
# omformulera $n med ny siffra 
#echo $m;
if [ $m -lt 10 ]; then n=000$m; elif [ $m -lt 100 ]; then n=00$m; elif [ $m -lt  1000 ]; then n=0$m; else n=9999;
fi
#n="stopp";
source="/src/harvahammas/corpora/de/split/SDA.9$i$j$k.$n.html"
target="/src/harvahammas/corpora/de/$tdir/SDA.lemma.9$i$j$k.$n.html"
#echo $m;
#echo $target;
done; # while test
done; # for k
done; # for j
done; # for i
