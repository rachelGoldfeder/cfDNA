#!/bin/bash

# USAGE: sh trimpairend.sh <fastq file R1>  <fastq file R2> 
#trimmed paired end reads

# load the modules
module load fastqc
module load java
module load trim_galore

# make directories to store output
mkdir -p trimmed_3bp

# Get input file
fq1=$1
fq2=$2

# Grab base of filename for future naming
base1=$(basename $fq1 .fastq.gz)
base2=$(basename $fq2 .fastq.gz)
trim1=${base1}_val_1.fq.gz
trim2=${base2}_val_2.fq.gz

# trim paired end reads
echo "Starting trimming of" $base1 "and" $base2
trim_galore --paired --stringency 3 --length 20 -q 30 --output_dir trimmed_3bp $fq1 $fq2

# run fastqc using cegxqc on trimmed reads

mkdir -p trimmed_3bp/fastqc
echo "Starting cegxqc of" $trim1
cegxqc -o trimmed_3bp/fastqc trimmed_3bp/$trim1
echo "Starting cegxqc of" $trim2
cegxqc -o trimmed_3bp/fastqc trimmed_3bp/$trim2 
