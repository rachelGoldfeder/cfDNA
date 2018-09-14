#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)!=7) {
  stop("At least seven arguments must be supplied", call.=FALSE)
}

#usage Rscript merge3_methbin_plot.R dir1 samp1 dir2 samp2 dir3 samp3 savedir


dir1=args[1]
samp1=args[2]
dir2=args[3]
samp2=args[4]
dir3=args[5]
samp3=args[6]
savedir=args[7]

library(data.table)
setwd(paste0(dir1))

a1=as.data.frame(fread(paste0("bis_",samp1,".binning.txt")))
b1=as.data.frame(fread(paste0("oxbis_",samp1,".binning.txt")))
c1=as.data.frame(fread(paste0("hmc_sigup_",samp1,".binning.txt")))

setwd(paste0(dir2))

a2=as.data.frame(fread(paste0("bis_",samp2,".binning.txt")))
b2=as.data.frame(fread(paste0("oxbis_",samp2,".binning.txt")))
c2=as.data.frame(fread(paste0("hmc_sigup_",samp2,".binning.txt")))

setwd(paste0(dir3))

a3=as.data.frame(fread(paste0("bis_",samp3,".binning.txt")))
b3=as.data.frame(fread(paste0("oxbis_",samp3,".binning.txt")))
c3=as.data.frame(fread(paste0("hmc_sigup_",samp3,".binning.txt")))

#pan =rgb(0,0.545098,0.545098,1/4)
#bla =rgb(0.729412,0.333333,0.827451,1/4)
#norm =rgb(0.560784,0.737255,0.560784,1/4)

setwd(paste0(savedir))

hist1=hist(a1$V7,breaks=20,xlim=c(0,100))
hist1$density = hist1$counts/sum(hist1$counts)*100
hist2=hist(a2$V7,breaks=20,xlim=c(0,100))
hist2$density = hist2$counts/sum(hist2$counts)*100
hist3=hist(a3$V7,breaks=20,xlim=c(0,100))
hist3$density = hist3$counts/sum(hist3$counts)*100

max=max(max(hist1$density),max(hist2$density),max(hist3$density))

pdf(paste0("bis_",samp1,samp2,samp3,"_bin.histall.pdf"))
par(mar=c(8.1, 4.1, 4.1, 2.1), xpd=TRUE)
plot(hist1,ylim=c(0,max),col=rgb(0.560784,0.737255,0.560784,1/4),main = "Histogram of % 5mC & 5hmC CpG methylation",xlab="% mc & hmC per base",freq=FALSE)
plot(hist2,col=rgb(0,0.545098,0.545098,1/4),add=T,freq=FALSE)
plot(hist3,col=rgb(0.729412,0.333333,0.827451,1/4),add=T,freq=FALSE)
legend("bottom", xpd=TRUE,c(paste0(samp1),paste0(samp2),paste0(samp3)), fill=c(rgb(0.560784,0.737255,0.560784,1/4),
rgb(0,0.545098,0.545098,1/4),col=rgb(0.729412,0.333333,0.827451,1/4)), horiz=T,xjust = .5,yjust = 1,bty = "n",inset=-.3)
dev.off()

hist1=hist(b1$V7,breaks=20,xlim=c(0,100))
hist1$density = hist1$counts/sum(hist1$counts)*100
hist2=hist(b2$V7,breaks=20,xlim=c(0,100))
hist2$density = hist2$counts/sum(hist2$counts)*100
hist3=hist(b3$V7,breaks=20,xlim=c(0,100))
hist3$density = hist3$counts/sum(hist3$counts)*100

max=max(max(hist1$density),max(hist2$density),max(hist3$density))

pdf(paste0("oxbis_",samp1,samp2,samp3,"_bin.histall.pdf"))
par(mar=c(8.1, 4.1, 4.1, 2.1), xpd=TRUE)
plot(hist1,ylim=c(0,max),col=rgb(0.560784,0.737255,0.560784,1/4),main = "Histogram of % 5mC CpG methylation",xlab="% mc & hmC per base",freq=FALSE)
plot(hist2,col=rgb(0,0.545098,0.545098,1/4),add=T,freq=FALSE)
plot(hist3,col=rgb(0.729412,0.333333,0.827451,1/4),add=T,freq=FALSE)
legend("bottom", xpd=TRUE,c(paste0(samp1),paste0(samp2),paste0(samp3)), fill=c(rgb(0.560784,0.737255,0.560784,1/4),
rgb(0,0.545098,0.545098,1/4),col=rgb(0.729412,0.333333,0.827451,1/4)), horiz=T,xjust = .5,yjust = 1,bty = "n",inset=-.3)
dev.off()

hist1=hist(c1$V4,breaks=20,xlim=c(0,1))
hist1$density = hist1$counts/sum(hist1$counts)*100
hist2=hist(c2$V4,breaks=20,xlim=c(0,1))
hist2$density = hist2$counts/sum(hist2$counts)*100
hist3=hist(c3$V4,breaks=20,xlim=c(0,1))
hist3$density = hist3$counts/sum(hist3$counts)*100

max=max(max(hist1$density),max(hist2$density),max(hist3$density))

pdf(paste0("hmc_sigup_",samp1,samp2,samp3,"_bin.hist.pdf"))
par(mar=c(8.1, 4.1, 4.1, 2.1), xpd=TRUE)
plot(hist1,ylim=c(0,max),col=rgb(0.560784,0.737255,0.560784,1/4),main = "Histogram of % 5hmC CpG methylation",xlab="% mc & hmC per base",freq=FALSE)
plot(hist2,col=rgb(0,0.545098,0.545098,1/4),add=T,freq=FALSE)
plot(hist3,col=rgb(0.729412,0.333333,0.827451,1/4),add=T,freq=FALSE)
legend("bottom", xpd=TRUE,c(paste0(samp1),paste0(samp2),paste0(samp3)), fill=c(rgb(0.560784,0.737255,0.560784,1/4),
rgb(0,0.545098,0.545098,1/4),col=rgb(0.729412,0.333333,0.827451,1/4)), horiz=T,xjust = .5,yjust = 1,bty = "n",inset=-.3)
dev.off()
