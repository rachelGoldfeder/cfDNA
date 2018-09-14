samp=$1

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -m ae -M alyssa.lau@jax.org
#PBS -V
#PBS -N $1.fulldata
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd \$PBS_O_WORKDIR

module load R

sh /projects/wei-lab/cfDNA/analysis/scripts/getFullData.hmc.sh $samp

Rscript /projects/wei-lab/cfDNA/analysis/scripts/5hmc_fullData.R ${samp}.fullData.txt

" >  $samp.fulldata.sh

qsub $samp.fulldata.sh
