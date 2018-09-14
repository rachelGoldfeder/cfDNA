#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)!=2) {
  stop("At least two argument must be supplied", call.=FALSE)
}

maindir=args[1] 
sampname=args[2]
methcalls=getwd()

setwd(paste0(maindir))

library(data.table)
files <- list.files(path = paste0(maindir),pattern = ".txt.bis.sorted")
temp <- lapply(files, fread, sep="\t", header = F)
bin <- rbindlist( temp )
attach(bin)
bin= bin[order(V1,V2),]
detach(bin)
bin=as.data.frame(bin)
colnames(bin)=c("chr","start","end","meth","nometh")
bin$all=bin$meth + bin$nometh
bin$val=(bin$meth/bin$all)*100

x=bin[c("chr","start","end","val","meth","nometh","all")]

setwd(paste0(methcalls))

write.table(as.data.frame(x),paste0("bis_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

setwd(paste0(maindir))

files <- list.files(path = paste0(maindir),pattern = ".txt.oxbis.sorted")
temp <- lapply(files, fread, sep="\t", header = F)
bin <- rbindlist( temp )
attach(bin)
bin= bin[order(V1,V2),]
detach(bin)

bin=as.data.frame(bin)
colnames(bin)=c("chr","start","end","meth","nometh")
bin$all=bin$meth + bin$nometh
bin$val=(bin$meth/bin$all)*100

y=bin[c("chr","start","end","val","meth","nometh","all")]

setwd(paste0(methcalls))
write.table(as.data.frame(y),paste0("oxbis_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0, 1.08*max(H$density)),...)
}

setwd(paste0(methcalls,"/plots"))

pdf(paste0("bis_",sampname,"_bin_histall.pdf"))
histPercent(x$val,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5mC & 5hmC CpG methylation: ",sampname),xlab="% mc & hmC per ba
se")
dev.off()

pdf(paste0("oxbis_",sampname,"_bin_histall.pdf"))
histPercent(y$val,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5mC CpG methylation: ",sampname),xlab="% mc per base")
dev.off()

methperc=matrix(c(sampname,sampname,"5mc & 5hmc percent","5mc percent",nrow(subset(x,val>0))/nrow(x),nrow(subset(y,val>0))/nrow(y)),nrow=2)
write.table(methperc,paste0(sampname,"_total_percent.txt"),col.names=F, row.names=FALSE, quote=FALSE, sep = "\t")

