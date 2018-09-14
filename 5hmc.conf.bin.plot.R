#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)!=2) {
  stop("At least two argument must be supplied", call.=FALSE)
}

maindir=args[1] 
sampname=args[2]

library(data.table)
methcalls=getwd()
setwd(paste0(maindir))

files <- list.files(path = paste0(maindir), pattern = ".conf.bed")
temp <- lapply(files, fread, sep="\t", header = F)
bin <- rbindlist( temp )
attach(bin)
bin= bin[order(V1,V2),]
detach(bin)

bin=as.data.frame(bin)
bin$allBS=bin$V5 + bin$V6
bin$alloxBS=bin$V7 + bin$V8
bin$val=bin$V4*100

bin=bin[c("V1","V2","V3","val","V5","V6","allBS","V7","V8","alloxBS")]

setwd(paste0(methcalls))


write.table(as.data.frame(bin),paste0("hmc_conf_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")
a=bin

histPercent <- function(i, ...) {
   H <- hist(i, plot = FALSE)
   H$density <- with(H, 100 * density* diff(breaks)[1])
   labs <- paste(round(H$density), "%", sep="")
   plot(H, freq = FALSE, labels = labs, ylim=c(0, 1.08*max(H$density)),...)
}

setwd(paste0(methcalls,"/plots"))

pdf(paste0("hmc_",sampname,"_confbin_histall.pdf"))
histPercent(a$val,col=rgb(0.128,0.128,0.128,1/4),main = paste0("Histogram of % 5hmC CpG methylation: ",sampname)
,xlab="% hmC per base")
dev.off()


methperc=matrix(c(sampname,"5hmc percent",nrow(subset(a,val>0))/nrow(a)),nrow=1)
write.table(methperc,paste0(sampname,"_total_percent.txt"),col.names=F, row.names=FALSE, quote=FALSE, sep = "\t", append=T)

