# Rachel Goldfeder
# Make Volcano Plots from RNA Seq Data
# March 2, 2018


########################################
# Load Libraries
########################################
#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

dir=getwd()


library(DESeq2)
library("ggplot2")
library("ggrepel")
sessionInfo()

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
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory= dir,
                                       design= ~ condition)
# Specify a reference level
ddsHTSeq$condition = relevel(ddsHTSeq$condition, ref = "Normal")


#######################################
# Differential Expression
#######################################

dds.de = DESeq(ddsHTSeq)
saveRDS(dds.de,"DESeq_dds.de.rds")

resultsNames(dds.de)

res1 = results(dds.de, contrast=c("condition","Tumor","Normal"))

#res1 = lfcShrink(dds.de, contrast=c("condition","Tumor","Normal"), res=res1)

results=as.data.frame(res1)
results$gene=row.names(res1)
results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
results$ensemble.ID=gsub("\\..*","",rownames(results))

write.table(results,"DESeq_results.txt",col.names=T,row.names=F,quote=F,sep="\t")

#######################################
# Normalize Countsq
#######################################

save.counts = counts(dds.de, normalized=TRUE)

write.table(save.counts, "save.counts.txt", quote=F)
save.counts_transpose = t(save.counts)
save.counts_machinelearning=cbind(sampleCondition,save.counts_transpose)
write.table(save.counts_machinelearning,"save.counts_transpose.txt",col.names=T,row.names=F,quote=F,sep="\t")

#######################################
# Volcano Plots
#######################################

sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]
signover.reg1=gsub("\\..*","",sig.reg1)

ensembl = read.table("/projects/wei-lab/cfDNA/analysis/TCGA_MDS/ensembl_ID_nover.txt", header=T, sep="\t")
colnames(ensembl) = c("ensemble.ID","geneName")

results.ensembl = merge(results, ensembl, by=c("ensemble.ID"))

volc = ggplot(results.ensembl, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle("Tumor vs Normal")  + theme_bw(20) 

#+ xlim(c(-7,7)) + ylim(c(-2,26))

pdf("TumorVsNormal.volc.pdf")
#volc + geom_text_repel(data=subset(results.bladder, -log10(pvalue)> 9 & abs(log2FoldChange)>2 ), aes(label=gene))
volc 
#+ geom_text_repel(data=subset(results.bladder.ensemble, gene %in% bla_cfDNA_set.ensembl$ensemble.ID & threshold==TRUE ), aes(label=geneName))
dev.off()

