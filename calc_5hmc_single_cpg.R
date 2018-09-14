#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

maindir=args[1] 
sampname=args[2]

library(data.table)

setwd(paste0(maindir))

bs=as.data.frame(fread(paste0("bis_",sampname,".cpg.txt")))
ox=as.data.frame(fread(paste0("oxbis_",sampname,".cpg.txt")))

colnames(bs)=c("chr","start","end","val","meth","nometh","all")
colnames(ox)=c("chr","start","end","val","meth","nometh","all")

both=merge(bs,ox,by=c("chr","start","end"))

attach(both)
ans=lapply(seq_along(meth.x), function(j) 
        prop.test(c(meth.x[j], meth.y[j]), c(meth.x[j] + nometh.x[j], meth.y[j] + nometh.y[j])))
detach (both)
        
pval = sapply(ans, '[[', 'p.value')
both$pval = pval
both$hmc = both$meth.x/(both$meth.x + both$nometh.x) - both$meth.y/(both$nometh.y + both$meth.y)

both$sum = both$meth.x + both$nometh.x + both$nometh.y + both$meth.y
both.sig = both[both$pval<0.05 & both$hmc > 0, ]

zeros = subset(both,(pval>=0.05|(val.x == val.y & (val.y == 0 | val.y ==100))) & sum>=0)
zeros$hmc[zeros$hmc!=0] =0

conf =rbind(both.sig, zeros)

write.table(as.data.frame(both),file=paste0("hmc_all_",sampname,".cpg.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")
both.sig2=both.sig[,c("chr","start","end","hmc","meth.x","nometh.x","meth.y","nometh.y")]
write.table(as.data.frame(both.sig2),file=paste0("hmc_sig_",sampname,".cpg.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")
conf2=conf[,c("chr","start","end","hmc","meth.x","nometh.x","meth.y","nometh.y")]
write.table(as.data.frame(conf2),file=paste0("hmc_conf_",sampname,".cpg.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")
