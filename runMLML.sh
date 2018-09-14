# run mlml
# Feb 7, 2018
# Rachel Goldfeder

bs=$1
oxbs=$2
base=`basename $1`

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N MLML
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR

module load methpipe/3.4.2
module load bedtools/2.17.0


bedtools intersect -a $bs  -b $oxbs -wa > $bs.both.txt
bedtools intersect -b $bs  -a $oxbs -wa > $oxbs.both.txt


sh /projects/wei-lab/cfDNA/analysis/scripts/cpgText_to_mlml.sh $bs.both.txt 
sh /projects/wei-lab/cfDNA/analysis/scripts/cpgText_to_mlml.sh $oxbs.both.txt 


mlml -u $bs.both.txt.forMLML.txt -m $oxbs.both.txt.forMLML.txt -o results.mlml.$base.txt " > sh.mlml.$base

qsub sh.mlml.$base
