# Rachel Goldfeder
# Make Volcano Plots from RNA Seq Data
# Oct 27, 2017


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

#sampleFiles <- grep("*/*.htseq.counts",list.files(getwd()),value=TRUE)
#print(sampleFiles)
sampleFiles = read.table("filenames.txt")
sampleNames = 1:nrow(sampleFiles) 
sampleCondition <- read.table("phenotype_ordered.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)
print(sampleTable)
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
resultsNames(dds.de)


res1 = results(dds.de, contrast=c("condition","Tumor","Normal"))

res1 = lfcShrink(dds.de, contrast=c("condition","Tumor","Normal"), res=res1)



#######################################
# Volcano Plots
#######################################


results=as.data.frame(res1)
results$gene=row.names(res1)

results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]


volc = ggplot(results, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle("Tumor vs Normal")  + theme_bw(20) 

pdf("TumorVsNormal.volc.pdf")
volc + geom_text_repel(data=subset(results, -log10(pvalue)> 20 & abs(log2FoldChange)>2 ), aes(label=gene))
dev.off()



write.csv(file="TvN.csv",results[compareNA(results$threshold, "TRUE"),], quote=F, row.names=F)


