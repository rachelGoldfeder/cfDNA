#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

maindir=args[1]
samp1=args[2]
samp2=args[3]
samp3=args[4]

library(data.table)

setwd(paste0(maindir)) 

a=as.data.frame(fread(paste0(maindir,"hmconly_",samp1,samp2,samp3,".gencode.bed")))
colnames(a)=c("chr","start","end","samp1","samp2","samp3","gchr","gstart","gend","gene","glength")

samp1genes=subset(a,samp1!=0&samp2==0&samp3==0)
write.table(as.data.frame(samp1genes),paste0("hmconly_",samp1,".gencode.txt"),col.names = F,row.names=F, quote=F, sep = "\t")
samp1geneslist=as.data.frame(unique(samp1genes$gene))
samp1geneslist=as.data.frame(samp1geneslist[samp1geneslist != ".",])
colnames(samp1geneslist)=c("samp1")
nrow(samp1geneslist) 

samp2genes=subset(a,samp1==0&samp2!=0&samp3==0)
write.table(as.data.frame(samp2genes),paste0("hmconly_",samp2,".gencode.txt"),col.names = F,row.names=F, quote=F, sep = "\t")
samp2geneslist=as.data.frame(unique(samp2genes$gene))
samp2geneslist=as.data.frame(samp2geneslist[samp2geneslist != ".",])
colnames(samp2geneslist)=c("samp2")
nrow(samp2geneslist)


samp3genes=subset(a,samp1==0&samp2==0&samp3!=0)
write.table(as.data.frame(samp3genes),paste0("hmconly_",samp3,".gencode.txt"),col.names = F,row.names=F, quote=F, sep = "\t")
samp3geneslist=as.data.frame(unique(samp3genes$gene))
samp3geneslist=as.data.frame(samp3geneslist[samp3geneslist != ".",])
colnames(samp3geneslist)=c("samp3")
nrow(samp3geneslist)

samp1reshape=reshape2::melt(samp1geneslist, id.vars = NULL)
samp2reshape=reshape2::melt(samp2geneslist, id.vars = NULL)
samp3reshape=reshape2::melt(samp3geneslist, id.vars = NULL)

both=merge(samp1reshape,samp2reshape,by=c("value"),all=T)
both[] <- lapply(both, function(x){
  # check if you have a factor first:
  if(!is.factor(x)) return(x)
  # otherwise include NAs into factor levels and change factor levels:
  x <- factor(x, exclude=NULL)
  levels(x)[is.na(levels(x))] <- "0"
  return(x)
  })

allgenes=merge(both,samp3reshape,by=c("value"),all=T) 
allgenes[] <- lapply(allgenes, function(x){
  # check if you have a factor first:
  if(!is.factor(x)) return(x)
  # otherwise include NAs into factor levels and change factor levels:
  x <- factor(x, exclude=NULL)
  levels(x)[is.na(levels(x))] <- "0"
  return(x)
  })

write.table(as.data.frame(allgenes),paste0("hmc_genes_",samp1,samp2,samp3,".txt"),col.names = F,row.names=F, quote=F, sep = "\t")

samp2only=subset(allgenes,variable.x=="0"&variable.y=="samp2"&variable=="0") 
samp2only=samp2only$value
write.table(as.data.frame(samp2only),paste0("hmc_genes_",samp2,".txt"),col.names = F,row.names=F, quote=F, sep = "\t")

samp3only=subset(allgenes,variable.x=="0"&variable.y=="0"&variable=="samp3")
samp3only=samp3only$value
write.table(as.data.frame(samp3only),paste0("hmc_genes_",samp3,".txt"),col.names = F,row.names=F, quote=F, sep = "\t")
