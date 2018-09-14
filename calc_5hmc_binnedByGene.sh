#PBS -l nodes=1:ppn=1
#PBS -l walltime=20:00:00
#PBS -q batch
#PBS -N calc5hmc_bingene_pipeline
#PBS -V
#PBS -m ae 
cd $PBS_O_WORKDIR
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0
module load R


sh /projects/wei-lab/cfDNA/analysis/scripts/binning_by_gene.sh
Rscript  /projects/wei-lab/cfDNA/analysis/scripts/calc_5hmc_binnedByGene.R 


cat confident.genes.csv| awk -F, -v OFS="\t" 'NR>1{print $1,$7,$2,$3,$4,$5}' |awk '{gsub(/\"/,"")};1'| sort -k1,1V -k2,2n > confident.genes.txt
