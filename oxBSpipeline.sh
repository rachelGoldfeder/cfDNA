#!/bin/bash

# USAGE: sh oxBSpipline.sh  <trimmed fastq file R1>  <trimmed fastq file R2>

# load the modules
module load fastqc
module load java
module load trim_galore
module load R
module load bedtools
module load cutadapt
module load samtools
module load bowtie2
module load python
module load perl
module load bismark/0.16.1

# Get input file
fq1=$1
fq2=$2

base=$(basename $fq1 _R1_val_1.fq.gz)
sam=$base.sam
bam=$base.bam
sorted_bam=$base-s.bam
clip=$base.clip.bam
mcall=$base.mcall.bdg
mcallall=$base.mcall.all.bdg
cytosine=$base.cytosine

# shorten trimmed reads and map to genome using bismark
echo "Starting the shortening and mapping of" $base
bsExpress -St -Sf -i $fq1 $fq2 -r ~/oxBS1/genome/h38.fa -p $base -Sb -Sc -Sm -Sr

# convert sam to bam and sort and index
echo "Start converting" $base "to bam"
samtools view -bS $base/$sam > $base/$bam
echo "Start sorting" $base
samtools sort $base/$bam -o $base/$sorted_bam
echo "Start indexing" $base
samtools index $base/$sorted_bam

#marking duplicates and clipping overlapping PE reads
echo "Start marking duplicates and clipping overlapping PE reads of" $base
bsExpress -St -Sf -i $base/$sorted_bam -r ~/oxBS1/genome/h38.fa -p $base -Ss -Sa -Sb -Md -Sm -Sr

#call CpG methylation
echo "Calling CpG methylation of" $base
bam2methylation.py -i $base/$clip -r ~/oxBS1/genome/h38.fa -l ~/oxBS1/genome/h38.allcpg.bed > $base/$mcall

#call all methylation
echo "Calling all methylation of" $base
bam2methylation.py -i $base/$clip -r ~/genome/h38.fa > $base/$mcallall

