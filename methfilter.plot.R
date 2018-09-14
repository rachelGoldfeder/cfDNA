#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

hmc=args[1] 
mc=args[2]
samp=args[3]

library(data.table)
methcalls=getwd()
setwd(paste0(methcalls))

x=as.data.frame(fread(hmc))
y=as.data.frame(fread(mc))

x1=subset(x,V4>0)
y1=subset(y,V4>0)

write.table(x1,paste0("hmc_sig_",samp,".binning.txt.filtered.cov5.hmc0.bed"),col.names=F, row.names=FALSE, quote=FALSE, sep = "\t")
write.table(y1,paste0("oxbis_sig_",samp,".binning.txt.filtered.cov5.mc0.bed"),col.names=F, row.names=FALSE, quote=FALSE, sep = "\t")

setwd(paste0(methcalls,"/plots"))

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0,25),...)
}

pdf(paste0(hmc,"_histmeth.pdf"))
histPercent(x1$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",samp),xlab="% hmC per base")
dev.off()

pdf(paste0(mc,"_histmeth.pdf"))
histPercent(y1$V4,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5mC CpG methylation: ",samp),xlab="% mc per base")
dev.off()


methperc=matrix(c(samp,samp,"5mc percent","5hmc percent",nrow(y1)/nrow(y),nrow(x1)/nrow(x)),nrow=2)
write.table(methperc,paste0(samp,"_total_percent.txt"),col.names=F, row.names=FALSE, quote=FALSE, sep = "\t")
