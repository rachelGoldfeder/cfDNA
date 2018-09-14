#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

samp=args[1]

library(data.table)

a=as.data.frame(fread(paste0("hmc_sig_",samp,".binning.txt.filtered.cov5_refGene.bed")))

exon=subset(a,V14=="exon")

exonhmc=exon[c("V16","V4")]

order=exonhmc[order(exonhmc$V16,-(exonhmc$V4)), ]

high= order[ !duplicated(order$V16), ]   

write.table(high,paste0("hmc_sig_",samp,".binning.txt.filtered.cov5_refGene.bed.high_hmc_geneExon.txt"),col.names=F,row.names=F,quote=F,sep="\t")
