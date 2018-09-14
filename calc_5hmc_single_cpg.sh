dir=$1
samp=$2

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=10:00:00
#PBS -q batch
#PBS -m ae -M alyssa.lau@jax.org
#PBS -V
#PBS -N $2.calc5hmc.singlecpg
#PBS -l mem=120G
#PBS -l pmem=120G
#PBS -l vmem=120G

cd \$PBS_O_WORKDIR

module load R/3.3.2

Rscript /projects/wei-lab/cfDNA/analysis/scripts/calc_5hmc_single_cpg.R $dir $samp
Rscript /projects/wei-lab/cfDNA/analysis/scripts/single_cpg_plot.R $dir $samp

" > $samp.calc5hmc_singlecpg_plot.sh

qsub $samp.calc5hmc_singlecpg_plot.sh 
