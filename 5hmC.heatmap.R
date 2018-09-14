#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

maindir=args[1]
samp1=args[2]
samp2=args[3]
samp3=args[4]

library(data.table)

setwd(paste0(maindir)) 
a=as.data.frame(fread(paste0(maindir,"hmc_conf_",samp1,".binning.txt")))
b=as.data.frame(fread(paste0(maindir,"hmc_conf_",samp2,".binning.txt")))
c=as.data.frame(fread(paste0(maindir,"hmc_conf_",samp3,".binning.txt")))

colnames(a)=c("chr","start","end","samp1","methbs","unmethbs","methox","unmethox")
colnames(b)=c("chr","start","end","samp2","methbs","unmethbs","methox","unmethox")
colnames(c)=c("chr","start","end","samp3","methbs","unmethbs","methox","unmethox")

a=a[c(1:4)]
b=b[c(1:4)]
c=c[c(1:4)]

both=merge(a,b,by=c(1:3))
all=merge(both,c,by=c(1:3))

nrow(all)
nrow(subset(all,samp1==0&samp2==0&samp3==0))
write.table(as.data.frame(all),paste0("hmcall_",samp1,samp2,samp3,".txt"),col.names = F,row.names=F, quote=F, sep = "\t")

#setwd(paste0(maindir,"plots"))

library(superheat)
my_all = as.data.frame(all[  ,c(4:6)])
my_all_r=my_all[sample(nrow(my_all),30000),]

png(paste0("hmcall_",samp1,samp2,samp3,"_heatmap.png"),1000,1000)
superheat(my_all_r,pretty.order.rows = TRUE,pretty.order.cols=TRUE)
dev.off()

png(paste0("hmcall_",samp1,samp2,samp3,"_heatmap_order.png"),1000,1000)
superheat(my_all_r,order.rows = order(my_all_r$samp1,my_all_r$samp2,my_all_r$samp3))
dev.off()

setwd(paste0(maindir))

allhmc=subset(all,samp1!=0|samp2!=0|samp3!=0)
nrow(allhmc)
write.table(as.data.frame(allhmc),paste0("hmconly_",samp1,samp2,samp3,".txt"),col.names = F,row.names=F, quote=F, sep = "\t")

#setwd(paste0(maindir,"plots"))
my_allhmc = as.data.frame(allhmc[  ,c(4:6)])
my_allhmc_r=my_allhmc[sample(nrow(my_allhmc),30000),]

png(paste0("hmconly_",samp1,samp2,samp3,"_heatmap.png"),1000,1000)
superheat(my_allhmc_r,pretty.order.rows = TRUE,pretty.order.cols=TRUE)
dev.off()

png(paste0("hmconly_",samp1,samp2,samp3,"_heatmap_order.png"),1000,1000)
superheat(my_allhmc_r,order.rows = order(my_allhmc_r$samp1,my_allhmc_r$samp2,my_allhmc_r$samp3))
dev.off()

