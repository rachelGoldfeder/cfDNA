file1=$1
file2=$2
file3=$3
out=$4

echo "

#PBS -l nodes=1:ppn=12
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N $out_merge_bis_bam_pipeline
#PBS -V
#PBS -m ae 

cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0

samtools merge $out_merge_results.bis.bam $file1_results.bis.sort.mDups.bam $file2_results.bis.sort.mDups.bam $file3_results.bis.sort.mDups.bam


" > $out_bis_merge.sh

qsub $out_bis_merge.sh

echo "

#PBS -l nodes=1:ppn=12
#PBS -l walltime=40:00:00
#PBS -q batch
#PBS -N $out_merge_oxbis_bam_pipeline
#PBS -V
#PBS -m ae

cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0

samtools merge $out_merge_results.oxbis.bam $file1_results.oxbis.sort.mDups.bam $file2_results.oxbis.sort.mDups.bam $file3_results.oxbis.sort.mDups.bam

" > $out_oxbis_merge.sh

qsub $out_oxbis_merge.sh

