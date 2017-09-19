#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q short
#PBS -N binning
#PBS -V
#PBS -m ae 
cd $PBS_O_WORKDIR


module load bedtools/2.17.0

for i in `seq 1 1 22 ` X Y
do
window=/projects/wei-lab/refs/h38/primaryAssembly/chr${i}.h38.all.200window.txt
bis_cpg=bis.cpg.txt
oxbis_cpg=oxbis.cpg.txt
out_filename=bis.oxbis.200window.$i.txt


bedtools intersect -a $window -b $oxbis_cpg -wao > $out_filename.temp1
awk '{if ($5 != -1){print}}' $out_filename.temp1 > $out_filename.temp
bedtools groupby -c 8,9 -o sum,sum -i $out_filename.temp > $out_filename.oxbis

rm $out_filename.temp
rm $out_filename.temp1

bedtools intersect -a $window -b $bis_cpg -wao > $out_filename.temp1.bis
awk '{if ($5 != -1){print}}' $out_filename.temp1.bis > $out_filename.temp.bis
bedtools groupby -c 8,9 -o sum,sum -i $out_filename.temp.bis > $out_filename.bis
rm $out_filename.temp.bis
rm  $out_filename.temp1.bis

sort -k 2b,2 $out_filename.bis > $out_filename.bis.sorted
sort -k 2b,2  $out_filename.oxbis > $out_filename.oxbis.sorted


join -1 2 -2 2 -t "	"  $out_filename.bis.sorted  $out_filename.oxbis.sorted > $out_filename

rm $out_filename.bis 
rm $out_filename.oxbis

#rm $out_filename.bis.sorted 
#rm $out_filename.oxbis.sorted

done
