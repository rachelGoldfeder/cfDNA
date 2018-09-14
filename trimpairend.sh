#!/bin/bash

# USAGE: sh trimpairend.sh <fastq file R1>  <fastq file R2> 
#trimmed paired end reads

# load the modules
module load fastqc
module load java
module load trim_galore

# make directories to store output
mkdir -p pairtrimfq

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
trim_galore --paired --length 20 -q 30 --output_dir pairtrimfq $fq1 $fq2

# fastqc using cegxqc on trimmed reads
echo "Starting cegxqc of" $trim1
cegxqc -o pairtrimfq pairtrimfq/$trim1
echo "Starting cegxqc of" $trim2
cegxqc -o pairtrimfq pairtrimfq/$trim2

# move orifq to orifq folder and move trimmedfq to parent folder
#mv pairtrimfq/*fq.gz .
