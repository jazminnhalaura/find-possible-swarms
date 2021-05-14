#!/bin/bash

dir='/Users/jazminnhalaura/seismic_progs/MatchLocate2-master/OBS/MultipleTemplate/find-swarms'

cd $dir;

cat DetectedFinal_all | awk '{print $2, "	", $3, "	", $4, "	", $5, "	", $7}' > isitswarm.tmp;

while read -r line; do

date=$(echo $line | awk '{print $1}');
time=$(echo $line | awk '{print $2}' | awk -F'.' '{print $1}');
ndatec=$(echo $line | awk '{print $1 $2}' | awk -F '/' '{print $1 $2 $3}');
ndate=$(echo $line | awk '{print $1}' | awk -F '/' '{print $1 $2 $3}');
date=$(gdate -d "$date" '+%Y/%m/%d');
sdate=$(gdate -d "$date - 1 days" '+%Y/%m/%d');
edate=$(gdate -d "$date + 1 days" '+%Y/%m/%d');
lat=$(echo $line | awk '{print $3}'); ((slat=$lat-.1)); ((elat=$lat+.1));
lon=$(echo $line | awk '{print $4}'); ((slon=$lon-.1));  ((elon=$lon+.1));
mag=$(echo $line | awk '{print $5}'); ((smag=$mag-.1)); ((emag=$mag+.1));

echo $date;

echo "time range: " $sdate $edate;
echo "latitude range: " $slat $elat; 
echo "longitude range: " $slon $elon;
echo "magnitude range: " $smag $emag;

#grep -E "$sdate|$date|$edate" DetectedFinal_all | awk '{if ($4>=slat && $4<=elat &&  $5>=slon && $5<=elon &&  $7>=smag && $7<=emag) print $0}' >> posswarm_"$ndate";
grep -E "$sdate|$date|$edate" DetectedFinal_all | awk '{if ($04>=slat && $04<=elat && $05>=slon && $05<=elon && $07>=smag); print $0}'  > posswarm_"$ndatec";

sort posswarm_"$ndate"* | uniq > posswarm_"$ndate"

ns=$(wc -l posswarm_"$ndate" | awk '{print $1}');

if [ $ns = 0 ]; then
rm posswarm_"$ndate"
echo "No swarms found for $date"
else
echo $date  $ns >> swarms_per_day;
fi

#sort posswarm_"$ndate" | uniq > posswarm_"$ndate"

done < isitswarm.tmp

#cat  posswarm_* > all_posswarms;

sort swarms_per_day | uniq > swarms_per_day_final
rm *.tmp
find . -name "*.*0" -print0 | xargs -0 rm 
