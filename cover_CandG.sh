file=$1
echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -N calc5hmc_CG
#PBS -V
#PBS -m ae 
cd \$PBS_O_WORKDIR
module load bedtools/2.17.0


bedtools intersect -a /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.allcpg_parsed.bed -b $file -c > $file.numCpG.txt

awk '{if(\$8==2){print \$1\"\t\"\$2\"\t\"\$3}}' $file.numCpG.txt > $file.CpGs_to_include.bed

bedtools intersect -a $file -b $file.CpGs_to_include.bed -wa  > $file.CpG.txt
" > $file.CpG.sh

