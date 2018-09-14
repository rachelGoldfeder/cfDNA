#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=7:00:00
#PBS -q batch
#PBS -N binningByGenes
#PBS -V
#PBS -m ae 
cd $PBS_O_WORKDIR


module load bedtools/2.17.0

bis_cpg=bis.cpg.txt
oxbis_cpg=oxbis.cpg.txt
out_filename=bis.oxbis.gene.txt

#mkdir temp
#cat  /projects/wei-lab/refs/h38/gene.list.names_new.txt | awk -F"\t" '{if($2=="protein_coding" && $3!~/GL/ && $3!~/CHR/ && $3!~/KI/){print}}' |   cut -f1 | sort| awk '{split($1,a,"."); print a[1]}' |  uniq > genes.uniq.txt
#for i in `cat genes.uniq.txt`; do grep -w $i  /projects/wei-lab/refs/h38/gene.list.names_new.txt | awk -F"\t"  '{if($3!~/CHR/) {print $3"\t"$4"\t"$5"\t"$1}}' | sort -k1,1n -k2,2n > temp/$i.bed; bedtools merge -i temp/$i.bed -nms > temp/$i.bed.merged ; done

#cat temp/*bed.merged | sort -k1,1 -k2,2n | uniq> genes.bed
#rm -rf temp/*
# sort -k1,1 -k2,2n genes.bed > genes.sorted.bed

ln -s /projects/wei-lab/refs/h38/primaryAssembly/refGeneParts.locs.TSS_TES.bigTranscriptsOnly_nochr.bed .

window=refGeneParts.locs.TSS_TES.bigTranscriptsOnly_nochr.bed

bedtools intersect -b $window -a $oxbis_cpg -wao > $out_filename.temp1
awk '{if ($8 != -1){print}}' $out_filename.temp1 | sort -k10,10 > $out_filename.temp
bedtools groupby -g 10 -c 5,6 -o sum,sum -i $out_filename.temp > $out_filename.oxbis

bedtools intersect -b $window -a $bis_cpg -wao > $out_filename.temp1.bis
awk '{if ($8 != -1){print}}' $out_filename.temp1.bis  | sort -k10,10 > $out_filename.temp.bis
bedtools groupby -g 10 -c 5,6 -o sum,sum -i $out_filename.temp.bis > $out_filename.bis

cat $out_filename.bis | sort -k1b,1 > $out_filename.gene.bis.sorted
cat $out_filename.oxbis | sort -k1b,1 > $out_filename.gene.oxbis.sorted

join -1 1 -2 1 -t "	"  $out_filename.gene.bis.sorted  $out_filename.gene.oxbis.sorted > $out_filename

rm $out_filename.temp
rm $out_filename.temp1

rm $out_filename.temp.bis
rm  $out_filename.temp1.bis

rm $out_filename.bis 
rm $out_filename.oxbis


