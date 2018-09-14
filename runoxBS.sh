# open to directory
#cd /projects/

#sh /projects/wei-lab/cfDNA/analysis/scripts/oxBSpipeline.sh <fastq file R1>  <fastq file R2>


fq1=$1
fq2=$2
ref=$3
cpg_bed=$4

sh /projects/wei-lab/cfDNA/analysis/scripts/oxBSpipeline_170808_AL.sh $fq1 $fq2 $ref $cpg_bed  


