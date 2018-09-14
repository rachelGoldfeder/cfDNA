# Rachel Goldfeder
# Make Volcano Plots from RNA Seq Data
# for genes that have 5hmc in the tumor/normal 
# January 12. 2018



########################################
# Load Libraries
########################################
library(DESeq2)
library(calibrate)
library("ggplot2")
library("ggrepel")


compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}



###########################################################################################
# cfDNA - BLADDER BOTH
###########################################################################################
#######################################
# Read in htseq-count data
#######################################

setwd('~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_171016/')

sampleFiles <- grep("Bla",list.files(getwd()),value=TRUE)
sampleNames = sub (".htseqcount", "",sampleFiles )
sampleCondition <- read.table("phenotype_ordered_2018.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)

#######################################
# Make dds using DESeqDataSetFromHTSeqCount
#######################################

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = getwd(),
                                       design= ~ condition)
# By default, R will choose a reference level for factors based on alphabetical order. Then, if you never tell the DESeq2 functions which level you want to compare against (e.g. which level represents the control group), the comparisons will be based on the alphabetical order of the levels. 
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

bla_cfDNA_set = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/hmc_N5xT1x_genesw5hmc_Bla.txt", header=F)
colnames(bla_cfDNA_set) = c("geneName")
ensembl = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/ensembl_ID.txt", header=T, sep="\t")
colnames(ensembl) = c("geneName","ensemble.ID")
bla_cfDNA_set.ensembl = merge(bla_cfDNA_set, ensembl, by="geneName")



results=as.data.frame(res1)
results$gene=row.names(res1)
results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]


results.bladder = results

results.bladder.ensemble = merge(results.bladder, ensembl, by.x="gene", by.y="ensemble.ID")


volc = ggplot(results.bladder, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle(" Bladder Tumor vs Normal")  + theme_bw(20) #+ xlim(c(-7,7)) + ylim(c(-2,26))

pdf("bladderTumorVsNormal.5hmc.volc.pdf")
#volc + geom_text_repel(data=subset(results.bladder, -log10(pvalue)> 9 & abs(log2FoldChange)>2 ), aes(label=gene))
volc + geom_text_repel(data=subset(results.bladder.ensemble, gene %in% bla_cfDNA_set.ensembl$ensemble.ID & threshold==TRUE ), aes(label=geneName))

dev.off()









###########################################################################################
# cfDNA - PANCREAS
###########################################################################################



sampleFiles <- grep("Pan",list.files(getwd()),value=TRUE)
sampleNames = sub (".htseqcount", "",sampleFiles )
sampleCondition <- read.table("phenotype_ordered3.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)

#######################################
# Make dds using DESeqDataSetFromHTSeqCount
#######################################

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = getwd(),
                                       design= ~ condition)
# By default, R will choose a reference level for factors based on alphabetical order. Then, if you never tell the DESeq2 functions which level you want to compare against (e.g. which level represents the control group), the comparisons will be based on the alphabetical order of the levels. 
# Specify a reference level
ddsHTSeq$condition = relevel(ddsHTSeq$condition, ref = "Normal")

# Collapse Technical Replicates
#dds.collapsed = collapseReplicates(ddsHTSeq, ddsHTSeq$condition)


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



pan_cfDNA_set = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/hmc_N5xT1x_genesw5hmc_Pan.txt", header=F)
colnames(pan_cfDNA_set) = c("geneName")

pan_cfDNA_set.ensembl = merge(pan_cfDNA_set, ensembl, by="geneName")


results=as.data.frame(res1)
results$gene=row.names(res1)

results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]


results.pancreas = results

results.pancreas.ensemble = merge(results.pancreas, ensembl, by.x="gene", by.y="ensemble.ID")


volc = ggplot(results.pancreas, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle(" Pancreas Tumor vs Normal")  + theme_bw(20) #+ xlim(c(-7,7)) + ylim(c(-2,26))

pdf("pancreasTumorVsNormal.5hmc.volc.pdf")
#volc + geom_text_repel(data=subset(results.pancreas, -log10(pvalue)> 9 & abs(log2FoldChange)>2 ), aes(label=gene))
volc + geom_text_repel(data=subset(results.pancreas.ensemble, gene %in% pan_cfDNA_set.ensembl$ensemble.ID & threshold==TRUE ), aes(label=geneName))

dev.off()










# Rachel Goldfeder
# Make Volcano Plots from RNA Seq Data
# for genes that have 5hmc in the tumor/normal 
# January 12. 2018



########################################
# Load Libraries
########################################
library(DESeq2)
library(calibrate)
library("ggplot2")
library("ggrepel")


compareNA <- function(v1,v2) {
  # This function returns TRUE wherever elements are the same, including NA's,
  # and false everywhere else.
  same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}



###########################################################################################
# cfDNA - BLADDER BOTH
###########################################################################################
#######################################
# Read in htseq-count data
#######################################

setwd('~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_171016/')

sampleFiles <- grep("Bla",list.files(getwd()),value=TRUE)
sampleNames = sub (".htseqcount", "",sampleFiles )
sampleCondition <- read.table("phenotype_ordered_2018.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)

#######################################
# Make dds using DESeqDataSetFromHTSeqCount
#######################################

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = getwd(),
                                       design= ~ condition)
# By default, R will choose a reference level for factors based on alphabetical order. Then, if you never tell the DESeq2 functions which level you want to compare against (e.g. which level represents the control group), the comparisons will be based on the alphabetical order of the levels. 
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

bla_cfDNA_set = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/hmc_N5xT1x_genesw5hmc_Bla.txt", header=F)
colnames(bla_cfDNA_set) = c("geneName")
ensembl = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/ensembl_ID.txt", header=T, sep="\t")
colnames(ensembl) = c("geneName","ensemble.ID")
bla_cfDNA_set.ensembl = merge(bla_cfDNA_set, ensembl, by="geneName")



results=as.data.frame(res1)
results$gene=row.names(res1)
results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]


results.bladder = results

results.bladder.ensemble = merge(results.bladder, ensembl, by.x="gene", by.y="ensemble.ID")


volc = ggplot(results.bladder, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle(" Bladder Tumor vs Normal")  + theme_bw(20) #+ xlim(c(-7,7)) + ylim(c(-2,26))

pdf("bladderTumorVsNormal.5hmc.volc.pdf")
#volc + geom_text_repel(data=subset(results.bladder, -log10(pvalue)> 9 & abs(log2FoldChange)>2 ), aes(label=gene))
volc + geom_text_repel(data=subset(results.bladder.ensemble, gene %in% bla_cfDNA_set.ensembl$ensemble.ID & threshold==TRUE ), aes(label=geneName))

dev.off()









###########################################################################################
# cfDNA - PANCREAS
###########################################################################################



sampleFiles <- grep("Pan",list.files(getwd()),value=TRUE)
sampleNames = sub (".htseqcount", "",sampleFiles )
sampleCondition <- read.table("phenotype_ordered3.txt")
colnames(sampleCondition) = "condition"
sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)

#######################################
# Make dds using DESeqDataSetFromHTSeqCount
#######################################

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = getwd(),
                                       design= ~ condition)
# By default, R will choose a reference level for factors based on alphabetical order. Then, if you never tell the DESeq2 functions which level you want to compare against (e.g. which level represents the control group), the comparisons will be based on the alphabetical order of the levels. 
# Specify a reference level
ddsHTSeq$condition = relevel(ddsHTSeq$condition, ref = "Normal")

# Collapse Technical Replicates
#dds.collapsed = collapseReplicates(ddsHTSeq, ddsHTSeq$condition)


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



pan_cfDNA_set = read.table("~/Documents/Projects/cfDNA/R_workspace/cfDNA_workspace_180112/hmc_N5xT1x_genesw5hmc_Pan.txt", header=F)
colnames(pan_cfDNA_set) = c("geneName")

pan_cfDNA_set.ensembl = merge(pan_cfDNA_set, ensembl, by="geneName")


results=as.data.frame(res1)
results$gene=row.names(res1)

results$threshold = as.factor(abs(results$log2FoldChange) > 2 & results$padj < 0.05)
sig.reg1 = results$gene[compareNA(results$threshold, "TRUE")]


results.pancreas = results

results.pancreas.ensemble = merge(results.pancreas, ensembl, by.x="gene", by.y="ensemble.ID")


volc = ggplot(results.pancreas, aes(log2FoldChange, -log10(pvalue))) + 
  geom_point(aes(col=threshold)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle(" Pancreas Tumor vs Normal")  + theme_bw(20) #+ xlim(c(-7,7)) + ylim(c(-2,26))

pdf("pancreasTumorVsNormal.5hmc.volc.pdf")
#volc + geom_text_repel(data=subset(results.pancreas, -log10(pvalue)> 9 & abs(log2FoldChange)>2 ), aes(label=gene))
volc + geom_text_repel(data=subset(results.pancreas.ensemble, gene %in% pan_cfDNA_set.ensembl$ensemble.ID & threshold==TRUE ), aes(label=geneName))

dev.off()










