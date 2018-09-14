#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

samphmc=args[1]
sampmc=args[2]
sampname=args[3]


library(data.table)
methcalls=getwd()
setwd(paste0(methcalls))

a=as.data.frame(fread(paste0(samphmc)))
b=as.data.frame(fread(paste0(sampmc)))
feat.mat=matrix(ncol=3,nrow=5)
ct=1
sum=0

for(i in c("promoter","exon","intron","intergenic")){
        feat=nrow(unique((subset(a,V14==i))[c(1:3)]))
        feat.mat[ct,1] = paste0("hmc_",sampname)
        feat.mat[ct,2] = i
        feat.mat[ct,3] = feat
        ct=ct+1
        sum=sum+feat
}

feat.mat[5,]= c(paste0("hmc_",sampname),"sum",sum)

setwd(paste0(methcalls,"/plots"))

write.table(feat.mat,paste0(sampname,"_feat_gene.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t", append=T)

feat.mat=matrix(ncol=3,nrow=5)
ct=1
sum=0

for(i in c("promoter","exon","intron","intergenic")){
        feat=nrow(unique((subset(b,V11==i))[c(1:3)]))
        feat.mat[ct,1] = paste0("mc_",sampname)
        feat.mat[ct,2] = i
        feat.mat[ct,3] = feat
        ct=ct+1
        sum=sum+feat
}

feat.mat[5,]= c(paste0("mc_",sampname),"sum",sum)

write.table(feat.mat,paste0(sampname,"_feat_gene.txt"),col.names = F,row.names=FALSE, quote=FALSE, sep = "\t", append=T)


