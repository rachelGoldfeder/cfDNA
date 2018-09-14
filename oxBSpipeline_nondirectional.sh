# Rachel Goldfeder
# Created on Aug 8, 2017
# Adapted from Alyssa Lau's:  /projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/oxBSpipeline.sh





# USAGE: sh oxBSpipeline_170808.sh  <trimmed fastq file R1>  <trimmed fastq file R2> </path/to/ref.fa> </path/to/cpg_forThisRef.bed>

# load the modules
module load fastqc
module load java
module load trim_galore
module load R
module load bedtools/2.17.0
module load cutadapt
module load samtools
module load bowtie2
module load python/2.7.3
module load perl
module load bismark/0.16.1
module load bamutil


# Get input file
fq1=$1
fq2=$2
ref=$3
cpg_bed=$4

base=$5
sam=$base.sam
bam=$base.bam
sorted_bam=$base.sorted.bam
clip=$base.clip.bam
mcall=$base.mcall.bdg
mcallall=$base.mcall.all.bdg
#cytosine=$base.cytosine

########################################################
# shorten trimmed reads and map to genome using bismark
# -St = skip adapter and quality trimming since it is already done
# -Sf = skip fastQC report
# -Sb = slip sam2bam 
# -Sc = skip clip
# -Sm = skip methylation call 
# -Sr = skip report
#######################################################

echo "Starting the shortening and mapping of" $base
#python -v /projects/wei-lab/cfDNA/analysis/scripts/bin/bsExpress -St -Sf -i $fq1 $fq2 -r $ref -p $base -Sb -Sc -Sm -Sr
bsExpress -St -Sf -i $fq1 $fq2 -r $ref -p $base -Sb -Sc -Sm -Sr --bismark_opts=--non_directional





#######################################################
# convert sam to bam and sort and index
#######################################################
echo "Start converting" $base "to bam"
samtools view -bS $base/$sam > $base/$bam
rm $base/$sam

echo "Start sorting" $base
samtools sort $base/$bam -o $base/$sorted_bam
rm $base/$bam

echo "Start indexing" $base
samtools index $base/$sorted_bam




#######################################################
#marking duplicates and clipping overlapping PE reads
# -St = skip adapter and quality trimming since it is already done
# -Sf = skip fastQC report
# -Sb = skip sam2bam 
# -Ss = skip shorten 
# -Sa = skip alignment
# -Md = mark duplicates
# -Sm = skip methylation call 
# -Sr = skip report
#######################################################
echo "Start marking duplicates and clipping overlapping PE reads of" $base
bsExpress -St -Sf -i $base/$sorted_bam -r $ref -p $base -Ss -Sa -Sb -Md -Sm -Sr



#call CpG methylation
echo "Calling CpG methylation of" $base
echo "/projects/wei-lab/cfDNA/analysis/scripts/cegx-bsexpress-ubuntu-14.04.4/cegx_bsexpress/oxbs_qc/bam2methylation.py -i $base/$clip -r $ref -l $cpg_bed > $base/$mcall"
/projects/wei-lab/cfDNA/analysis/scripts/cegx-bsexpress-ubuntu-14.04.4/cegx_bsexpress/oxbs_qc/bam2methylation.py -i $base/$clip -r $ref -l $cpg_bed > $base/$mcall



#call all methylation
echo "Calling all methylation of" $base
/projects/wei-lab/cfDNA/analysis/scripts/cegx-bsexpress-ubuntu-14.04.4/cegx_bsexpress/oxbs_qc/bam2methylation.py -i $base/$clip -r $ref > $base/$mcallall






