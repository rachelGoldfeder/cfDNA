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

print("read files")
x=as.data.frame(fread("bis.cpg.txt",header=TRUE))
print("file1 done")
y=as.data.frame(fread("oxbis.cpg.txt",header=TRUE))
print("file2 done")

colnames(x)=c("chr","start","end","val","meth","nometh")
colnames(y)=c("chr","start","end","val","meth","nometh")

x$all=x$meth + x$nometh
y$all=y$meth + y$nometh

x=subset(x,chr=="1"|chr=="2"|chr=="3"|chr=="4"|chr=="5"|chr=="6"|chr=="7"|chr=="8"|chr=="9"|chr=="10"|chr=="11"|chr=="12"|chr=="13"|chr=="14"|chr=="15"|chr=="16"|chr=="17"|chr=="18"|chr=="19"|chr=="20"|chr=="21"|chr=="22"|chr=="X"|chr=="Y")
y=subset(y,chr=="1"|chr=="2"|chr=="3"|chr=="4"|chr=="5"|chr=="6"|chr=="7"|chr=="8"|chr=="9"|chr=="10"|chr=="11"|chr=="12"|chr=="13"|chr=="14"|chr=="15"|chr=="16"|chr=="17"|chr=="18"|chr=="19"|chr=="20"|chr=="21"|chr=="22"|chr=="X"|chr=="Y")

x = droplevels(x)
y = droplevels(y)

setwd(paste0(methcalls))

write.table(as.data.frame(x),file=paste0("bis_",sampname,".cpg.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")
write.table(as.data.frame(y),file=paste0("oxbis_",sampname,".cpg.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

w = table(x$all)
w2 = table(y$all)
t = as.data.frame(w)
t2 = as.data.frame(w2)
t$percent = (100*(t$Freq/(58689794)))
t2$percent = (100*(t2$Freq/(58689794)))
head(t)
head(t2)
t = t[-c(1),]
t2 = t2[-c(1),]

setwd(paste0(methcalls,"/plots"))

pdf(paste0(sampname,"_cov.pdf"))
plot(t$percent,xlim = c(0,25),ylim = c(0,25),type="h",xlab="coverage",ylab="%", lwd = 4,col=rgb(0,.5,0,1/4))
par(new=TRUE)
plot(t2$percent,xlim = c(0,25),ylim = c(0,25),type="h",xlab="coverage",ylab="%",lwd = 4,col=rgb(0,0,.5,1/4)) 
dev.off()


perc.mat=matrix(nrow=10,ncol=3)
for (i in 1:10) {
	percbs=nrow(subset(x,all>=i))/58689794
	percox=nrow(subset(y,all>=i))/58689794
	perc.mat[i,1]= i
	perc.mat[i,2]=percbs
	perc.mat[i,3]=percox 
}


colnames(perc.mat)=c("cov","BS CpG percent","oxBS CpG percent")
write.table(perc.mat,paste0(sampname,"_cpgcov_percent.txt"),row.names=FALSE, quote=FALSE,sep="\t")
