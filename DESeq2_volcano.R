#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

genelist=args[1]

library("ggplot2")
library(data.table)
results=as.data.frame(fread("../DESeq_results.txt"))

genes=read.table("ensembl_ID_nover.txt",header=T,sep='\t')
sample=read.table(paste0(genelist),header=F)
colnames(sample)=c("Gene.name")

sampgenes=merge(genes,sample,by=c("Gene.name"))

sampgenesresults=merge(sampgenes,results,by.x=c("Gene.stable.ID"), by.y=c("V9"))
sampgenesresults.sig=subset(sampgenesresults,V8=="TRUE")


write.table(sampgenesresults.sig,paste0(genelist,"_TCGA_sig.txt"),col.names=F,row.names=F,quote=F,sep="\t")
write.table(sampgenesresults,paste0(genelist,"_TCGA_all.txt"),col.names=F,row.names=F,quote=F,sep="\t")


volc = ggplot(sampgenesresults, aes(V2, -log10(V5))) + labs(x = "log2FoldChange") + labs(y = "-log10(pvalue)") +
  geom_point(aes(col=V8)) + #add points colored by significance
  scale_color_manual(values=c("black", "red"), guide=FALSE) + 
  ggtitle("Tumor vs Normal")  + theme_bw(20) 

pdf(paste0(genelist,".volc.pdf"))

volc

dev.off()



