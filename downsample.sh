module load java/1.8.0

java -jar /projects/wei-lab/cfDNA/analysis/scripts/picard.jar DownsampleSam \
      I=$INFILE \
      P=$PERCENT \
      O=$OUTFILE
    

