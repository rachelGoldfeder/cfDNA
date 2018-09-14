# Rachel Goldfeder
# Make Volcano Plots from RNA Seq Data
# March 2, 2018


########################################
# Load Libraries
########################################
library(DESeq2)
library("ggplot2")
library("ggrepel")


compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}


#######################################
# Read in htseq-count data
#######################################

sampleFiles = read.table("filenames.txt")
sampleNames = 1:nrow(sampleFiles) 
sampleCondition <- read.table("phenotype_ordered.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)
#######################################
# Make dds using DESeqDataSetFromHTSeqCount
#######################################
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory="/projects/wei-lab/cfDNA/analysis/rnaSeq/tcga/",
                                       design= ~ condition)
# Specify a reference level
ddsHTSeq$condition = relevel(ddsHTSeq$condition, ref = "Normal")



#######################################
# Differential Expression
#######################################

dds.de = DESeq(ddsHTSeq)


#######################################
# Normalize Counts
#######################################

save.counts = counts(dds.de, normalized=TRUE)

write.table(save.counts, "save.counts.txt", quote=F)
