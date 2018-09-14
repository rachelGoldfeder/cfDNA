name=$1


echo "
#PBS -l nodes=1:ppn=12
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N call_meth_CHH
#PBS -V
#PBS -m ae
cd \$PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R


##bis
/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract --CHH -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  $1_results.bis.sort.mDups.bam --noCpG -o $1_results.bis

##oxbis

/projects/wei-lab/cfDNA/analysis/scripts/MethylDackel extract --CHH -@ 12  /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa  $1_results.oxbis.sort.mDups.bam --noCpG -o $1_results.oxbis


"> call_meth_CHH.sh


qsub call_meth_CHH.sh
