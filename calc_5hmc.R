#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

samp=args[1]

library(data.table)
dir=getwd()

bs=as.data.frame(fread(paste0("bis_",samp,".cpg.txt")))
ox=as.data.frame(fread(paste0("oxbis_",samp,".cpg.txt")))

colnames(bs)=c("chr","start","end","val","meth","nometh","total")
colnames(ox)=c("chr","start","end","val","meth","nometh","total")

both=merge(bs,ox,by=c("chr","start","end"))

attach(both)
ans=lapply(seq_along(meth.x), function(j) 
        prop.test(c(meth.x[j], meth.y[j]), c(total.x[j], total.y[j])))
detach (both)
        
print("p.value")

pval = sapply(ans, '[[', 'p.value')
both$pval = pval
both$hmc = both$meth.x/both$total.x - both$meth.y/both$total.y

both$sum = both$total.x + both$total.y
both.sig = both[both$pval<0.05 & both$hmc > 0, ]

zeros = subset(both,(pval>=0.05|(val.x == val.y & (val.y == 0 | val.y ==100))) & sum>=0)
zeros$hmc[zeros$hmc!=0] =0

conf =rbind(both.sig, zeros)

write.csv(both, file=paste0("hmc_all_",samp,".cpg.csv"))
both.sig$hmc2= both.sig$hmc*100
both.sig2=both.sig[c("chr","start","end","hmc2","meth.x","nometh.x","total.x","meth.y","nometh.y","total.y")]
write.table(both.sig2,paste0("hmc_sig_",samp,".cpg.csv"),col.names=F,row.names=F,quote=F,sep="\t")
conf$hmc2= conf$hmc*100
conf2=conf[c("chr","start","end","hmc2","meth.x","nometh.x","total.x","meth.y","nometh.y","total.y")]
write.table(conf2, paste0("hmc_confident_",samp,".cpg.csv"),col.names=F,row.names=F,quote=F,sep="\t")
