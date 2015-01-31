#!/bin/bash
touch 199512.ord;
touch 199512.xml;
for k in 1201 1202 1203 1204 1205 1206 1207 1208 1209 1210 1211 1212 1213 1214 1215 1216 1217 1218 1219 1220 1221 1222 1223 1224 1225 1226 1227 1228 1229 1230 1231;
do
../bin/kattaihopochtaborttaggar.perl ../tt/1995$k* >>199512.ord;
../bin/slaaihopochreknaomtaggar.perl ../tt/1995$k* >>199512.xml;
done;
