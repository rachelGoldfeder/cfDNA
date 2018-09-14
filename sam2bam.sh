#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l walltime=134:00:00
#PBS -q long
#PBS -N bwameth_38
#PBS -V
#PBS -m ae -M Rachel.Goldfeder@jax.org
cd $PBS_O_WORKDIR

module load samtools

sam=reads.GA.75.sam
bam=reads.GA.75.bam

samtools view -S -b $sam > $bam
