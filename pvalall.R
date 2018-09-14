#! /usr/bin/env Rscript

read.bedgraph <- function(file) {
  dat <- scan(file=file, 
          what=list(character(),integer(),integer(),numeric(),integer(),integer(),character()), 
          sep="\t")
  dat <- data.frame(chr=dat[[1]], start=dat[[2]], end=dat[[3]],
          val=dat[[4]], unchange=dat[[5]], all=dat[[6]], strand=dat[[7]])
  return(dat)
}

F1 = read.bedgraph("normBSall/normBSall.mcall.bdg")
F2 = read.bedgraph("normoxBSall/normoxBSall.mcall.bdg")
F1$x = paste(F1$chr,F1$start)
F2$x = paste(F2$chr,F2$start)
F1F2= merge(F1,F2, by ="x")
samp=subset(F1F2,F1F2$all.x>=1 & F1F2$all.y>=1)
attach(samp)
ans=lapply(seq_along(unchange.x), function(i) 
prop.test(c(unchange.x[i],unchange.y[i]),c(all.x[i],all.y[i])))
detach(samp)
samppval=sapply(ans, '[[', 'p.value')
samp2=cbind(samp,samppval)
samp2$hmc = (samp2$val.x - samp2$val.y)

keep = c("chr.x","start.x","end.x","hmc","samppval","val.x","unchange.x","all.x","val.y","unchange.y","all.y","strand.y")
sampnew=samp2[keep]

write.table(as.data.frame(sampnew),"hmc-norm-cov.bdg",col.names = FALSE,row.names=FALSE, quote=FALSE, sep = "\t") 

hmc=subset(samp2,samp2$hmc >0)
keep = c("chr.x","start.x","end.x","hmc","samppval","val.x","unchange.x","all.x","val.y","unchange.y","all.y","strand.y")
hmc=hmc[keep]
hmc$pval = format(round(hmc$samppval,5),scientific=FALSE)
keep = c("chr.x","start.x","end.x","hmc","pval","val.x","unchange.x","all.x","val.y","unchange.y","all.y","strand.y")
hmc=hmc[keep]

write.table(as.data.frame(hmc),"hmc-norm-pval.bdg",col.names = FALSE,row.names=FALSE, quote=FALSE, sep = "\t")

attach(hmc)
hmcsig=subset(hmc,pval < 0.05)
head(hmcsig)
detach(hmc)

write.table(as.data.frame(hmcsig),"hmc-norm-sig.bdg",col.names = FALSE,row.names=FALSE, quote=FALSE, sep = "\t")


