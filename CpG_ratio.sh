echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -N CpG_ratio
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR

module load R

Rscript /projects/wei-lab/cfDNA/analysis/scripts/ratio_0.25.R $1 

" > $1.CpG_ratio.sh

qsub $1.CpG_ratio.sh
