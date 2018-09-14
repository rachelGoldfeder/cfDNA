#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

maindir=args[1] 
sampname=args[2]

library(data.table)

setwd(paste0(maindir))

a=as.data.frame(fread(paste0("hmc_sig_",sampname,".cpg.txt")))

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0, 1.08*max(H$density)),...)
}

setwd(paste0(maindir,"plots"))

pdf(paste0("hmc_",sampname,"_sigupcpg_hist.pdf"))
histPercent(a$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",sampname),xlab="% hmC per base")
dev.off()
