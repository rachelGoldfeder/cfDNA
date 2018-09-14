# RNA Seq Analysis Pipeline
# Rachel Goldfeder
# Created on May 29, 2018
# Updated on July 20, 2018





################################
# 0. Functions
###############################

# make output dir
function mk_outdir {
outputDir=$1
if [ ! -d $outputDir ]; then
    echo "Creating $outputDir"
    mkdir $outputDir
fi
}


for i in `cat fileNames.txt `; do fname=`basename $i .fastq.gz`; sample=`echo $fname | sed  's/_R[12]//'`; echo $sample >> temp;  done
sort temp | uniq > finalList.txt
rm temp










#################################
# Trim adapters
################################
jobArray=''
mkdir trimFq

cd trimFq

for i in `cat ../fileNames.txt`; do ln -s $i . ;done

for i in `ls *R1.fastq.gz`; do

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=30:00:00
#PBS -q batch
#PBS -N Trimming_RNASeq
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
sh /projects/wei-lab/cfDNA/analysis/scripts/trimpairend_170815.sh $i `echo $i | sed 's/R1/R2/'` " > $i.trim.sh;
done

for i in `ls *trim.sh`; do
job=`qsub $i`;
if [ "$jobArray" = "" ]
then
	jobArray="$job"
else
	jobArray="$jobArray:$job"
fi
done

cd ../


##################################
## Hisat
## adapted from Harianto
#################################

hisatJA=""
mkdir hisat
cd hisat
submitdir=$PWD
datadir="$PWD/../trimFq/trimmed_3bpMatch/"
R1suf="_R1_val_1.fq.gz"
R2suf="_R2_val_2.fq.gz"

refgen="/projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly_tran"
gtf="/projects/wei-lab/refs/h38/gencode.v27.primary_assembly.annotation.noChr.gtf"
nthread=7


function pbsjob_hisat {
    #fname=`basename $1`
    #sample=$(echo $fname | cut -d'_' -f1)
    sample=$1
    pbs="$1.rna.sh"
    read1=${datadir}${sample}${R1suf}
    read2=${datadir}${sample}${R2suf}

mk_outdir $sample

cd $sample

cat << ENDHERE > $pbs
#!/bin/bash
#PBS -l nodes=1:ppn=$nthread
#PBS -l vmem=48gb
#PBS -l walltime=48:00:00
#PBS -m ae
#PBS -q batch
#PBS -V



cd \$PBS_O_WORKDIR

module load hisat2/2.1.0
module load samtools
module load stringtie

echo "Hisat2 on $sample"

#1. map reads to transcript ref
#--dta-cufflinks is in addition to --dta option
hisat2 -p $nthread --dta-cufflinks -x $refgen -1 $read1 -2 $read2 -S $sample.sam

#2. sort & convert SAM -> BAM (direct way, using unsorted way first had been tested to be identical result.)
samtools sort -@ $nthread -T tmp_$sample -O bam -o $sample.bam  $sample.sam

#3. Assemble & quantify expresssed genes/transcripts
stringtie -p $nthread  -G $gtf -o $sample.gtf -l "$sample"  $sample.bam


echo "removing $sample.sam ... "
/bin/ls -ltr $sample.sam
rm $sample.sam
#echo "Hisat2 on $sample DONE."


ENDHERE

job=`qsub  -W depend=afterok:$jobArray $pbs`
if [ "$hisatJA" = "" ]
then
        hisatJA="$job"
else
        hisatJA="$hisatJA:$job"
fi

cd $submitdir

}


while read myarg ; do
   pbsjob_hisat $myarg
done < ../finalList.txt


cd ../




#################################
# htseq
# adapted from Harianto
################################


mkdir htseq
cd htseq
submitdir=$PWD

#nthread=1
#gtf="/projects/wei-lab/refs/h38/gencode.v27.primary_assembly.annotation.noChr.gtf" 
datadir='$PWD/../hisat'


function pbsjob_htseq {
    sample=$1
    pbs="$sample.htseqcount.sh"
    inbam=${datadir}/${sample}/$sample.bam


cat << ENDHERE > $pbs
#!/bin/bash
#PBS -j oe
#PBS -l nodes=1:ppn=$nthread
#PBS -l vmem=4gb
#PBS -l walltime=8:00:00
#PBS -m a


cd \$PBS_O_WORKDIR

module load python/2.7.13
python ~/.local/bin/HTSeq/scripts/count.py -s=reverse -q -m union --nonunique all -f bam $inbam $gtf > $sample.htseqcount

ENDHERE

qsub  -W depend=afterok:$hisatJA $pbs
}

while read myarg ; do
   pbsjob_htseq $myarg
done < ../finalList.txt


cd ../



###################################
## cufflinks
## addapted from Harianto
#################################

mkdir cufflinks
cd cufflinks

submitdir=$PWD
gnomefa="/projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
gtf="/projects/wei-lab/refs/h38/gencode.v27.primary_assembly.annotation.noChr.noRNA.gtf"
maskgtf="/projects/wei-lab/refs/h38/gencode.v27.primary_assembly.mask.gtf"



function pbsjob_cufflinks {
    sample=$1
    pbs="$sample.cuf.sh"
    inbam=${datadir}/${sample}/$sample.bam

#mk_outdir $sample
#cd $sample

cat << ENDHERE > $pbs
#!/bin/bash
#PBS -j oe
#PBS -l nodes=1:ppn=$nthread
#PBS -l vmem=24gb
#PBS -l walltime=30:00:00
#PBS -m a


cd \$PBS_O_WORKDIR

module load samtools
module load cufflinks/2.2.1

echo "cufflinks on $sample"

cufflinks -p $nthread -o $sample -G $gtf -M $maskgtf -b $gnomefa -u --no-update-check --seed 1122334455 --library-type fr-firststrand $inbam
echo "cufflinks on $sample DONE."

date

ENDHERE

qsub  -W depend=afterok:$hisatJA $pbs
cd $submitdir

}


while read myarg ; do
   pbsjob_cufflinks $myarg
done < ../finalList.txt




cd ../



#################################
# run  DESeq2
################################
