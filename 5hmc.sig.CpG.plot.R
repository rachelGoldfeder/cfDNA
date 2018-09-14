#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

sampname=args[1]
dir=getwd()
library(data.table)

#a=as.data.frame(fread(paste0("hmc_conf_",sampname,".cpg.txt"),header=F))
asig=as.data.frame(fread(paste0("hmc_sig_",sampname,".cpg.txt"),header=F))

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
  #plot(H, freq = FALSE, labels = labs,  ylim=c(0, 1.08*max(H$density)),...)
   plot(H, freq = FALSE, labels = labs,  ylim=c(0,35),...)	
}

setwd(paste0(dir,"/plots"))

pdf(paste0("hmc_",sampname,"_sigupCpG_hist.pdf"))
histPercent(asig$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",sampname),xlab="% hmC per base")
dev.off()


#pdf(paste0("hmc_",sampname,"_confCpG_histall.pdf"))
#histPercent(a$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",sampname)
#,xlab="% hmC per base")
#dev.off()


