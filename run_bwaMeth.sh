#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l walltime=134:00:00
#PBS -q long
#PBS -N bwameth_38
#PBS -V
#PBS -m ae -M Rachel.Goldfeder@jax.org
cd $PBS_O_WORKDIR



fq1=/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/trim/trimmed_3bpMatch/BS-norm-cfDNA-3_R1_val_1.fq.gz
fq2=/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/trim/trimmed_3bpMatch/BS-norm-cfDNA-3_R2_val_2.fq.gz
outSam=/projects/wei-lab/cfDNA/analysis/firstSet/try_bwaMeth/bs-norm-ln3-trim3-grch38PA-bwaMeth.sam

module load bwa/0.7.12
module load samtools
module load python/2.7.3



python  /projects/wei-lab/cfDNA/analysis/scripts/bwa-meth-master/bwameth.py  --threads 12 --reference /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa $fq1 $fq2 > $outSam

samtools view -S -b $outSam > ${outSam}.bam
