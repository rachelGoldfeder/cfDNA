file=$1
echo "#PBS -l nodes=1:ppn=1
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N countNs
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load samtools

samtools view  -F 4 $file | cut -f10 | grep \"N\" | wc -l > $file.numReadsWithNs.txt " > $file.submit

qsub $file.submit
