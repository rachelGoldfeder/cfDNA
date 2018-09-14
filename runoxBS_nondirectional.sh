#PBS -l nodes=1:ppn=1
#PBS -l walltime=80:00:00
#PBS -q long
#PBS -m ae -M rachel.goldfeder@jax.org
#PBS -V
#PBS -N oxbs_38_primary_12bpTrimmed_directional
#PBS -l mem=60G
#PBS -l pmem=60G
#PBS -l vmem=60G

cd $PBS_O_WORKDIR

sh /projects/wei-lab/cfDNA/analysis/scripts/oxBSpipeline_nondirectional.sh /projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3_R1_trim3bp.fq.gz  /projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3_R2_trim3bp.fq.gz /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa /projects/wei-lab/refs/h38/primaryAssembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.allcpg_parsed.bed directional_3bpTrim 


