#PBS -l nodes=1:ppn=1
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -m ae -M alyssa.lau@jax.org
#PBS -V
#PBS -N getNormalizedCounts
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd $PBS_O_WORKDIR

module load R/3.3.2

Rscript /projects/wei-lab/cfDNA/analysis/scripts/getNormalizedCounts_DESeq2_AL.R




