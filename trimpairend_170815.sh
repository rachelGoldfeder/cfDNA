#!/bin/bash

# USAGE: sh trimpairend.sh <fastq file R1>  <fastq file R2> 
#trimmed paired end reads

# load the modules
module load fastqc
module load java
module load trim_galore

# make directories to store output
mkdir -p trimmed_3bpMatch

# Get input file
fq1=$1
fq2=$2


# trim paired end reads
echo "Starting trimming of" $fq1 "and" $fq2
trim_galore --paired --stringency 3 --length 20 -q 30 --output_dir trimmed_3bpMatch $fq1 $fq2




# run fastqc  on trimmed reads

mkdir trimmed_3bpMatch/fastqc

fastqc -o  trimmed_3bpMatch/fastqc -f fastq trimmed_3bpMatch/*fq.gz 
