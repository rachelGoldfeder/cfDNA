#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

sampname=args[1]

methcalls=getwd()

library(data.table)

a=as.data.frame(fread(paste0(sampname)))

nrow(subset(a,V11<0))/nrow(a)

setwd(paste0(methcalls,"/plots"))

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE,breaks=40)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0,25),xlim=c(-100,100),...)
}


pdf(paste0(sampname,".pdf"))
histPercent(a$V11*100,col=rgb(0.128,0.128,0.128,1/4),main = "Histogram of % 5hmC CpG methylation",xlab="% hmC per base")
dev.off()

pdf(paste0(sampname,"cov_scatter.pdf"))
smoothScatter(a$V11*100,a$V12,ylim=c(0,200),xlab="methylation %",ylab="coverage")
dev.off()

