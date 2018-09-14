#####################################################
# Pipeline to Analyze cfDNA
# Rachel Goldfeder
# Sept 11, 2017
#####################################################


bis_fq1=$1
bis_fq2=$2
oxbis_fq1=$3
oxbis_fq2=$4
outPrefix=$5
enhancer=$6
STEP=${7:-1} # if you don't provide a step, it will start from the beginning, steps are listed below:

# 1. Align reads with BWA-Meth
# 2. Process Aligned Reads & QC
# 3. Mark duplicates with biscuit & QC
# 4. Call methylation with MethylDackel
# 5. Check for c and g to both have coverage
# 6. Bin all calls in 200 bp windows
# 7. Calculate 5hmc based on statistically significantly different bins
# 8. Creating meth_calls dir and making plots


#####################################################
# 1. Align reads with BWA-Meth
#####################################################
echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N sleep
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR

sleep 1" > sleep.sh

FIRST_bis=`qsub sleep.sh`
FIRST_oxbis=`qsub sleep.sh`
SECOND_bis=`qsub sleep.sh`
SECOND_oxbis=`qsub sleep.sh`
THIRD_bis=`qsub sleep.sh`
THIRD_oxbis=`qsub sleep.sh`
FOURTH_bis=`qsub sleep.sh`
FOURTH_oxbis=`qsub sleep.sh`
FOURTH_bis_1=`qsub sleep.sh`
FOURTH_oxbis_1=`qsub sleep.sh`
FIFTH=`qsub sleep.sh`
SIXTH=`qsub sleep.sh`


if [ "$STEP" -lt "2" ]; then

echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N align_bis_cfDNA_pipeline
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > align.bis.sh


echo "
##bis
python  /projects/wei-lab/cfDNA/analysis/scripts/bwa-meth-master/bwameth.py  --threads 12 --reference /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa $bis_fq1 $bis_fq2 > $outPrefix.bis.sam
" >> align.bis.sh


echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N align_oxbis_cfDNA_pipeline
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > align.oxbis.sh

echo "
## oxbis
python  /projects/wei-lab/cfDNA/analysis/scripts/bwa-meth-master/bwameth.py  --threads 12 --reference /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa $oxbis_fq1 $oxbis_fq2 > $outPrefix.oxbis.sam
" >> align.oxbis.sh




FIRST_bis=`qsub align.bis.sh`
FIRST_oxbis=`qsub align.oxbis.sh`
fi

#####################################################
# 2. Process Aligned Reads & QC
#####################################################

if [ "$STEP" -lt "3" ]; then

echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=10:00:00
#PBS -q batch
#PBS -N process_bis_cfDNA_pipeline
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R"  > process.bis.sh



echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=10:00:00
#PBS -q batch
#PBS -N process_oxbis_cfDNA_pipeline
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R"  > process.oxbis.sh

echo "
##bis
samtools view -S -b $outPrefix.bis.sam > ${outPrefix}.bis.bam


rm $outPrefix.bis.sam

samtools sort -@ 11 ${outPrefix}.bis.bam > ${outPrefix}.bis.sort.bam

rm $outPrefix.bis.bam
samtools index ${outPrefix}.bis.sort.bam

samtools flagstat ${outPrefix}.bis.sort.bam > ${outPrefix}.bis.flagstat
" >> process.bis.sh


echo "
##oxbis
samtools view -S -b $outPrefix.oxbis.sam > ${outPrefix}.oxbis.bam


rm $outPrefix.oxbis.sam

samtools sort -@ 11 ${outPrefix}.oxbis.bam > ${outPrefix}.oxbis.sort.bam

rm $outPrefix.oxbis.bam
samtools index ${outPrefix}.oxbis.sort.bam

samtools flagstat ${outPrefix}.oxbis.sort.bam > ${outPrefix}.oxbis.flagstat
" >> process.oxbis.sh





SECOND_bis=`qsub -W depend=afterok:$FIRST_bis process.bis.sh`
SECOND_oxbis=`qsub -W depend=afterok:$FIRST_oxbis process.oxbis.sh`

fi

####################################################
# 3. Mark duplicates with biscuit & QC
#####################################################

if [ "$STEP" -lt "4" ]; then

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -N markDups_bis_cfDNA_pipeline
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load bwa.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > markDups.bis.sh



echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -N markDups_oxbis_cfDNA_pipeline
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > markDups.oxbis.sh



echo "
##bis
/projects/wei-lab/cfDNA/analysis/scripts/biscuit-release/biscuit markdup ${outPrefix}.bis.sort.bam  ${outPrefix}.bis.mDups.bam
samtools sort ${outPrefix}.bis.mDups.bam > ${outPrefix}.bis.sort.mDups.bam


samtools flagstat ${outPrefix}.bis.sort.mDups.bam > ${outPrefix}.bis.mdups.flagstat
" >>markDups.bis.sh

echo "
##oxbis
/projects/wei-lab/cfDNA/analysis/scripts/biscuit-release/biscuit markdup ${outPrefix}.oxbis.sort.bam  ${outPrefix}.oxbis.mDups.bam
samtools sort ${outPrefix}.oxbis.mDups.bam > ${outPrefix}.oxbis.sort.mDups.bam

samtools flagstat ${outPrefix}.oxbis.sort.mDups.bam > ${outPrefix}.oxbis.mdups.flagstat
" >> markDups.oxbis.sh


THIRD_bis=`qsub -W depend=afterok:$SECOND_bis markDups.bis.sh`
THIRD_oxbis=`qsub -W depend=afterok:$SECOND_oxbis markDups.oxbis.sh`


fi


#####################################################
# 4. Call methylation with MethylDackel
# MethylDackel extract
#####################################################

if [ "$STEP" -lt "5" ]; then

echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N callMeth_bis_cfDNA_pipeline
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > callMeth.bis.sh



echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N callMeth_oxbis_cfDNA_pipeline
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R" > callMeth.oxbis.sh


echo "

##bis
/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract -l  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.allcpg_parsed.bed -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  ${outPrefix}.bis.sort.mDups.bam

/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract --CHH --noCpG -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  ${outPrefix}.bis.sort.mDups.bam 
" >> callMeth.bis.sh


echo "
##oxbis
/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract  -l  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.allcpg_parsed.bed -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  ${outPrefix}.oxbis.sort.mDups.bam 

/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract --CHH  --noCpG -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  ${outPrefix}.oxbis.sort.mDups.bam 
" >> callMeth.oxbis.sh

FOURTH_bis_1=`qsub -W depend=afterok:$THIRD_bis callMeth.bis.sh`
FOURTH_oxbis_1=`qsub -W depend=afterok:$THIRD_oxbis callMeth.oxbis.sh`
fi

#####################################################
# 5. Check for c and g to both have coverage
#####################################################


if [ "$STEP" -lt "6" ]; then



sh /projects/wei-lab/cfDNA/analysis/scripts/cover_CandG.sh ${outPrefix}.bis.sort.mDups_CpG.bedGraph 
FOURTH_bis=`qsub -W depend=afterok:$FOURTH_bis_1 ${outPrefix}.bis.sort.mDups_CpG.bedGraph.CpG.sh`
sh /projects/wei-lab/cfDNA/analysis/scripts/cover_CandG.sh ${outPrefix}.oxbis.sort.mDups_CpG.bedGraph
FOURTH_oxbis=`qsub -W depend=afterok:$FOURTH_oxbis_1 ${outPrefix}.oxbis.sort.mDups_CpG.bedGraph.CpG.sh`

fi

#####################################################
# 6. Bin all calls in 200 bp windows
#####################################################
if [ "$STEP" -lt "7" ]; then



ln -s ${outPrefix}.bis.sort.mDups_CpG.bedGraph bis.cpg.txt
ln -s ${outPrefix}.oxbis.sort.mDups_CpG.bedGraph oxbis.cpg.txt




FIFTH=`qsub -W depend=afterok:$FOURTH_bis:$FOURTH_oxbis /projects/wei-lab/cfDNA/skvortsova_2017/scripts/binning.sh`


fi



#####################################################
# 7. Calculate 5hmc based on statistically significantly different bins
#####################################################

if [ "$STEP" -lt "8" ]; then

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

#for i in `seq 1 1 22` X Y ; do echo "bedtools intersect  -a ${outPrefix}.$i.conf.bed -b /projects/wei-lab/refs/h38/gencode.grch38.noChr.txt -wao > ${outPrefix}.$i.conf.gencode.bed"; done >> calc5hmc.sh

#for i in `seq 1 1 22` X Y ; do echo "bedtools intersect  -a ${outPrefix}.$i.conf.gencode.bed -b /projects/wei-lab/refs/h38/featureType_regulatoryFeatures.bed -wao > ${outPrefix}.$i.conf.gencode.regFeatures.bed"; done >> calc5hmc.sh



SIXTH=`qsub -W depend=afterok:$FIFTH calc5hmc.sh`
fi
#####################################################
# 8. Creating meth_calls dir and making plots
#####################################################
if [ "$STEP" -lt "9" ]; then

mkdir ../meth_calls
sampleDir=$PWD
cd ../meth_calls


sh /projects/wei-lab/cfDNA/analysis/scripts/meth.plot.sh $sampleDir $outPrefix 5 $enhancer 


qsub -W depend=afterok:$SIXTH $outPrefix.run.sh

fi
