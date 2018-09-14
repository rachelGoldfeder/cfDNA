#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q short
#PBS -N geneNames
#PBS -V
#PBS -m ae 

cd $PBS_O_WORKDIR
module load bedtools/2.17.0
module load R


#Rscript /projects/wei-lab/cfDNA/skvortsova_2017/scripts/calc_5hmc_binned.R


#for i in `seq 1 1 22` X Y ; do cat confident.$i.csv | awk -F"," -v OFS="\t" 'NR>1{print $3,$2,$4,$12}' | sort -k2,2n > ${outPrefix}.$i.conf.bed; done

#for i in `seq 1 1 22` X Y ; do bedtools intersect  -a ${outPrefix}.$i.conf.bed -b /projects/wei-lab/refs/h38/gencode.grch38.noChr.txt -wao > ${outPrefix}.$i.conf.gencode.bed; done 

for i in `seq 1 1 22` X Y ; do bedtools intersect  -a ${outPrefix}.$i.conf.gencode.bed -b /projects/wei-lab/refs/h38/featureType_regulatoryFeatures.bed -wao > ${outPrefix}.$i.conf.gencode.regFeatures.bed; done

