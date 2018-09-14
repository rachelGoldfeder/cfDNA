# USAGE: sh redocallmeth.sh <clipped.bam> </path/to/ref.fa> </path/to/cpg_forThisRef.bed>

# load the modules
module load fastqc
module load java
module load trim_galore
module load R
module load bedtools/2.17.0
module load cutadapt
module load samtools
module load bowtie2
module load python/2.7.3
module load perl
module load bismark/0.16.1
module load bamutil


# Get input file
clip=$1
ref=$2
cpg_bed=$3

base=$(basename $clip .clip.bam)
mcall=$base.new.mcall.bdg
mcallall=$base.new.mcall.all.test.bdg


#call CpG methylation
echo "Calling CpG methylation of" $base
echo "bam2methylation.py -i $clip -r $ref -l $cpg_bed > $base/$mcall"
/projects/wei-lab/cfDNA/analysis/scripts/cegx-bsexpress-ubuntu-14.04.4/cegx_bsexpress/oxbs_qc/bam2methylation.py -i $clip -r $ref -l $cpg_bed > $base/$mcall



#call all methylation
echo "Calling all methylation of" $base
/projects/wei-lab/cfDNA/analysis/scripts/cegx-bsexpress-ubuntu-14.04.4/cegx_bsexpress/oxbs_qc/bam2methylation.py -i $clip -r $ref > $base/$mcallall



