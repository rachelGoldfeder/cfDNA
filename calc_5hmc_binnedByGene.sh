#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q short
#PBS -N calc5hmc_bingene_pipeline
#PBS -V
#PBS -m ae 
cd $PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R

Rscript  /projects/wei-lab/cfDNA/analysis/scripts/calc_5hmc_binnedByGene.R 
