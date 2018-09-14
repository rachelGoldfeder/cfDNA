#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)!=2) {
  stop("At least two argument must be supplied", call.=FALSE)
}

maindir=args[1] 
sampname=args[2]

library(data.table)

setwd(paste0(maindir,sampname))

files <- list.files(path = paste0(maindir,sampname), pattern = ".conf.gencode.bed")
temp <- lapply(files, fread, sep="\t", header = F)
bin <- rbindlist( temp )
attach(bin)
bin= bin[order(V1,V2),]
detach(bin)

setwd(paste0(maindir,"meth_calls"))

write.table(as.data.frame(bin),paste0("hmc_conf_genecode_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

setwd(paste0(maindir,sampname))

files <- list.files(path = paste0(maindir,sampname), pattern = ".conf.gencode.regFeatures.bed")
temp <- lapply(files, fread, sep="\t", header = F)
bin <- rbindlist( temp )
attach(bin)
bin= bin[order(V1,V2),]
detach(bin)

setwd(paste0(maindir,"meth_calls"))

write.table(as.data.frame(bin),paste0("hmc_conf_genefeat_",sampname,".binning.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

a=as.data.frame(bin)
a=subset(a,V4>0)

feat.mat=matrix(ncol=3,nrow=9)
ct=1
sum=0

for(i in c("feature_type=Promoter","feature_type=Promoter Flanking Region","feature_type=Enhancer",
"feature_type=CTCF Binding Site","feature_type=TF binding site","feature_type=Open chromatin")){
	feat=nrow(unique((subset(a,V17==i))[c(1:3)]))
	feat.mat[ct,1] = sampname
	feat.mat[ct,2] = i
	feat.mat[ct,3] = feat 
	ct=ct+1
	sum=sum+feat
}

gene=nrow(unique((subset(a,V17=="."&V12!="."))[c(1:3)]))
interg=nrow(unique((subset(a,V17=="."&V12=="."))[c(1:3)]))

feat.mat[7,]= c(sampname,"feature_type=Gene",gene)
feat.mat[8,]= c(sampname,"feature_type=Intergenic",interg)
feat.mat[9,]= c(sampname,"feature_type=Sum",sum+gene+interg)

setwd(paste0(maindir,"meth_calls/plots"))
write.table(feat.mat,paste0(sampname,"_feat_dist.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t")

#print("Feature distribution")
#nrow(unique((subset(a,V17=="feature_type=Promoter"))[c(1:3)]))
#nrow(unique((subset(a,V17=="feature_type=Promoter Flanking Region"))[c(1:3)]))
#nrow(unique((subset(a,V17=="feature_type=Enhancer"))[c(1:3)]))
#nrow(unique((subset(a,V17=="feature_type=CTCF Binding Site"))[c(1:3)]))
#nrow(unique((subset(a,V17=="feature_type=TF binding site"))[c(1:3)]))
#nrow(unique((subset(a,V17=="feature_type=Open chromatin"))[c(1:3)]))
#nrow(unique((subset(a,V17=="."&V12!="."))[c(1:3)]))
#nrow(unique((subset(a,V17=="."&V12=="."))[c(1:3)]))
#print("Total Unique")

