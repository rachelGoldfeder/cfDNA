# cfDNA

This pipeline performs the following steps:

## For BS and OxBS separately:
- Align reads with BWA-Meth to Grch38-Primary Assembly
- Process reads with samtools (run flagstat for QC)
- Mark dups with Biscuit
- Call methylation with Methyldackel
## For BS and OxBS together:
- Run prop.test and subtraction to calculate 5hmc amount (R)
- Create relevant plots (R)


The pipeline qsubs the jobs individually for each one of these tasks (which each wait to run until the previous step completes) – and runs a separate job for BS-seq and OxBS-seq, so everything is parallelized and overall it runs pretty quickly.

On Helix, the pipeline is located here:

/projects/wei-lab/cfDNA/analysis/scripts/pipeline.sh

To run it, the syntax is:

sh /projects/wei-lab/cfDNA/analysis/scripts/pipeline.sh <bis_fastq1_name.fq.gz> <bis_fastq2_name.fq.gz> <oxbis_fastq1_name.fq.gz> <oxbis_fastq2_name.fq.gz> <outFilePrefix>  [OPTIONAL: step to start on]

Example:

sh /projects/wei-lab/cfDNA/analysis/scripts/pipeline.sh Adult_Brain_Bis_1.fastq.gz.2M Adult_Brain_Bis_2.fastq.gz.2M Adult_Brain_OxBis_1.fastq.gz.2M Adult_Brain_OxBis_2.fastq.gz.2M adult_brain_test  1


I’d recommend running the pipeline in the same directory as your fastq files, so that you can just use their names (rather than full path) and the output files will also be placed in this same dir. One easy way to do this without moving lots of files around is just to create the new dir you want to work in and then link your fastq files in. For example:

####make and change to new dir
mkdir bladderCa_lane1
cd bladderCa_lane1

####link in fq files
ln –s /path/to/bis_fq1.gz .
ln –s /path/to/bis_fq2.gz .
ln –s /path/to/oxbis_fq1.gz .
ln –s /path/to/oxbis_fq2.gz .

####run the pipeline!
sh /projects/wei-lab/cfDNA/analysis/scripts/pipeline.sh bis_fq1.gz bis_fq2.gz oxbis_fq1.gz oxbis_fq2.gz bladderCa_results

If you run a qstat, you should see that the alignment jobs immediately start running (or are queued), and the rest of the jobs are in state “H” for holding.
