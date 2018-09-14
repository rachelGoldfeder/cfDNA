#####################################################
# Pipeline to Analyze 5hmc
# Rachel Goldfeder
# March 21, 2018
#####################################################


outPrefix=$1




#####################################################
# 3. Check for c and g to both have coverage
#####################################################





sh /projects/wei-lab/cfDNA/analysis/scripts/cover_CandG.sh ${outPrefix}.bis.sort.mDups_CpG.bedGraph 
FOURTH_bis=`qsub CpG.sh`
sh /projects/wei-lab/cfDNA/analysis/scripts/cover_CandG.sh ${outPrefix}.oxbis.sort.mDups_CpG.bedGraph
FOURTH_oxbis=`qsub CpG.sh`

#####################################################
# 4. Bin all calls in 200 bp windows
#####################################################

ln -s ${outPrefix}.bis.sort.mDups_CpG.bedGraph.CpG.txt bis.cpg.txt
ln -s ${outPrefix}.oxbis.sort.mDups_CpG.bedGraph.CpG.txt oxbis.cpg.txt


FIFTH=`qsub -W depend=afterok:$FOURTH_bis:$FOURTH_oxbis /projects/wei-lab/cfDNA/skvortsova_2017/scripts/binning.sh`






#####################################################
# 5. Calculate 5hmc based on statistically significantly different bins
#####################################################

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N calc5hmc_cfDNA_pipeline
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > calc5hmc.sh

echo "Rscript /projects/wei-lab/cfDNA/skvortsova_2017/scripts/calc_5hmc_binned.R" >> calc5hmc.sh


for i in `seq 1 1 22` X Y ; do echo  "cat confident.$i.csv | awk -F"," -v OFS=\"\t\" 'NR>1{print \$3,\$2,\$4,\$12,\$5,\$6,\$9,\$10}' | sed 's/\"//g' | sort -k2,2n > ${outPrefix}.$i.conf.bed"; done >> calc5hmc.sh

for i in `seq 1 1 22` X Y ; do echo "bedtools intersect  -a ${outPrefix}.$i.conf.bed -b /projects/wei-lab/refs/h38/gencode.grch38.noChr.txt -wao > ${outPrefix}.$i.conf.gencode.bed"; done >> calc5hmc.sh

for i in `seq 1 1 22` X Y ; do echo "bedtools intersect  -a ${outPrefix}.$i.conf.gencode.bed -b /projects/wei-lab/refs/h38/featureType_regulatoryFeatures.bed -wao > ${outPrefix}.$i.conf.gencode.regFeatures.bed"; done >> calc5hmc.sh



SIXTH=`qsub -W depend=afterok:$FIFTH calc5hmc.sh`


