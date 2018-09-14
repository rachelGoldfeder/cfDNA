sample=$1

echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N $1.run.tabulateConversionRate
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR

sh /projects/wei-lab/cfDNA/analysis/scripts/tabulateConversionRate.sh $1_results.bis.sort.mDups_CHH.bedGraph
sh /projects/wei-lab/cfDNA/analysis/scripts/tabulateConversionRate.sh $1_results.oxbis.sort.mDups_CHH.bedGraph

" >$1.run.tabulateConversionRate.sh

qsub $1.run.tabulateConversionRate.sh
