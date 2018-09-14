file=$1
echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N noRepeats
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR 


module load bedtools/2.17.0

bedtools intersect -a $file -b /projects/wei-lab/refs/h38/primaryAssembly/repeatMasker.grch38.bed -v > $file.noRepeats.bed " > $file.sh.noRepeats

qsub $file.sh.noRepeats
