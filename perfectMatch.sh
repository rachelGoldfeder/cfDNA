echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -N perfectMatch
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load samtools





samtools view -H $1 > $1.perfectMatch.sam

samtools view -@ 11 $1 | awk '\$0 ~\"NM:i:0\"' >> $1.perfectMatch.sam

samtools view -@ 11 -b $1.perfectMatch.sam > $1.perfectMatch.bam

samtools index $1.perfectMatch.bam

rm $1.perfectMatch.sam
" > $1.perfMatch.sh

qsub $1.perfMatch.sh
