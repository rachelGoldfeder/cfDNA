#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

sampname=args[1]
methcalls=getwd()
library(data.table)

a=as.data.frame(fread(paste0("hmc_conf_",sampname,".binning.txt"),header=F))

asig=subset(a,V4>0)

write.table(as.data.frame(asig),paste0("hmc_sigup_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0, 25),...)
}

setwd(paste0(methcalls,"/plots"))

pdf(paste0("hmc_",sampname,"_sigupbin_hist.pdf"))
histPercent(asig$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",sampname),xlab="% hmC per base")
dev.off()
