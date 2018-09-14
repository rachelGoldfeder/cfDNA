
dir=$1  #directory of CpG and bins (sample directory/)
samp=$2 #sample name for future naming 
cov=$3  #coverge requirement for bin
enhancer=$4  #enhancer location

base=$(basename $enhancer _nochr.csv_loc.txt)

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -m ae  
#PBS -V
#PBS -N $2.meth.plot
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd \$PBS_O_WORKDIR   #working directory needs to be methcalls (or dir where you want things saved)

module load R
module load bwa/0.7.12
module load samtools
module load python/2.7.3
module load bedtools/2.17.0

mkdir -p plots

Rscript /projects/wei-lab/cfDNA/analysis/scripts/cpg_percent.R $dir $samp
#Rscript /projects/wei-lab/cfDNA/analysis/scripts/bsoxbin.R $dir $samp
Rscript /projects/wei-lab/cfDNA/analysis/scripts/bsoxbin_ylim.R $dir $samp
Rscript /projects/wei-lab/cfDNA/analysis/scripts/5hmc.conf.bin.plot.R $dir $samp
#Rscript /projects/wei-lab/cfDNA/analysis/scripts/5hmc.sig.bin.plot.R $dir $samp
Rscript /projects/wei-lab/cfDNA/analysis/scripts/5hmc.sig.bin.plot_ylim.R $samp

mkdir -p cov
mkdir -p cov/plots
mkdir -p cpg
mv *${samp}.cpg.txt cpg

sh /projects/wei-lab/cfDNA/analysis/scripts/prioritize_filter.5mc_5hmc.sh hmc_conf_${samp}.binning.txt $cov 0 hmc
sh /projects/wei-lab/cfDNA/analysis/scripts/prioritize_filter.5mc_5hmc.sh oxbis_${samp}.binning.txt $cov 0 mc
mv hmc_conf_${samp}.binning.txt.filtered.cov${cov}.hmc0.bed cov
mv oxbis_${samp}.binning.txt.filtered.cov${cov}.mc0.bed cov

cd cov

Rscript /projects/wei-lab/cfDNA/analysis/scripts/methfilter.plot.R hmc_conf_${samp}.binning.txt.filtered.cov${cov}.hmc0.bed oxbis_${samp}.binning.txt.filtered.cov${cov}.mc0.bed $samp

ln -s /projects/wei-lab/refs/h38/primaryAssembly/refGeneParts.locs.bigTranscriptsOnly_andIntergenic_nochr.txt refGene_loc.bed
ln -s $enhancer 

bedtools intersect -a hmc_sig_${samp}.binning.txt.filtered.cov${cov}.hmc0.bed -b refGene_loc.bed -wao > hmc_sig_${samp}.binning.txt.filtered.cov${cov}_refGene.bed
bedtools intersect -a oxbis_sig_${samp}.binning.txt.filtered.cov${cov}.mc0.bed -b refGene_loc.bed -wao > oxbis_sig_${samp}.binning.txt.filtered.cov${cov}_refGene.bed
Rscript /projects/wei-lab/cfDNA/analysis/scripts/gene_feat.R  hmc_sig_${samp}.binning.txt.filtered.cov${cov}_refGene.bed oxbis_sig_${samp}.binning.txt.filtered.cov${cov}_refGene.bed $samp

bedtools intersect -a hmc_sig_${samp}.binning.txt.filtered.cov${cov}.hmc0.bed -b ${base}_nochr.csv_loc.txt -wao > hmc_sig_${samp}.binning.txt.filtered.cov${cov}_${base}.bed
bedtools intersect -a oxbis_sig_${samp}.binning.txt.filtered.cov${cov}.mc0.bed -b ${base}_nochr.csv_loc.txt -wao > oxbis_sig_${samp}.binning.txt.filtered.cov${cov}_${base}.bed
Rscript /projects/wei-lab/cfDNA/analysis/scripts/enhancer.R  hmc_sig_${samp}.binning.txt.filtered.cov${cov}_${base}.bed oxbis_sig_${samp}.binning.txt.filtered.cov${cov}_${base}.bed $samp

" > $samp.run.sh


#qsub $samp.run.sh
