dir=$1
samp1=$2
samp2=$3
samp3=$4

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -m ae -M alyssa.lau@jax.org
#PBS -V
#PBS -N 5mC.heatmap.gene
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd \$PBS_O_WORKDIR

module load R/3.3.2
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0

Rscript /projects/wei-lab/cfDNA/analysis/scripts/5mC.heatmap.R $dir $samp1 $samp2 $samp3

bedtools intersect -a mcall_${samp1}${samp2}${samp3}.txt -b /projects/wei-lab/refs/h38/gencode.grch38.noChr.txt -wao > mcall_${samp1}${samp2}${samp3}.gencode.bed 

Rscript /projects/wei-lab/cfDNA/analysis/scripts/5mC.gene.R $dir $samp1 $samp2 $samp3

" > 5mC_heatmap_gene.sh


qsub 5mC_heatmap_gene.sh
