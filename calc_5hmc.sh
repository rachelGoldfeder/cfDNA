samp=$1 #sample name for future naming

echo "
#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=7:00:00
#PBS -q batch
#PBS -N $1_calc_5hmC_bin
#PBS -V
#PBS -m ae

cd \$PBS_O_WORKDIR
module load R/3.3.2

Rscript /projects/wei-lab/cfDNA/analysis/scripts/calc_5hmc.R $samp

" > $samp.calc_5hmC_bin_run.sh

qsub $samp.calc_5hmC_bin_run.sh


