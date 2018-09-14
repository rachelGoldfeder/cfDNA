samp=$1
enh=$2

echo "
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -q batch
#PBS -m ae -M alyssa.lau@jax.org
#PBS -V
#PBS -N $1.gene.uniq
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd \$PBS_O_WORKDIR

mkdir -p exon_inton_genelist
mkdir -p exon_inton_genelist/Exon
mkdir -p exon_inton_genelist/ExonIntron
mkdir -p exon_inton_genelist/Intron
mkdir -p enhancer_genelist



sh /projects/wei-lab/cfDNA/analysis/scripts/exonintron_gene_uniq.sh  hmc_sig_${samp}.binning.txt.filtered.cov5_refGene.bed hmc
sh /projects/wei-lab/cfDNA/analysis/scripts/exonintron_gene_uniq.sh  oxbis_sig_${samp}.binning.txt.filtered.cov5_refGene.bed mc

mv *.geneExonIntron.* exon_inton_genelist/ExonIntron
mv *.geneExon.* exon_inton_genelist/Exon
mv *.geneIntron.* exon_inton_genelist/Intron

sh /projects/wei-lab/cfDNA/analysis/scripts/enhancer_gene_uniq.sh  hmc_sig_${samp}.binning.txt.filtered.cov5_${enh}.bed hmc
sh /projects/wei-lab/cfDNA/analysis/scripts/enhancer_gene_uniq.sh  oxbis_sig_${samp}.binning.txt.filtered.cov5_${enh}.bed mc

mv *geneEnh* enhancer_genelist

" > $samp.gene.uniq.sh

qsub $samp.gene.uniq.sh
