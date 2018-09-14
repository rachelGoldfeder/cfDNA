#! /usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

sampname=args[1]

library(data.table)

samp=as.data.frame(fread(paste0(sampname)))

toDelete <- seq(1, nrow(samp), 2)
sampOdd=samp[ toDelete ,]

toDelete <- seq(0, nrow(samp), 2)
sampEven=samp[ toDelete ,]

colnames(sampOdd)=c("chrO","startO","endO","methpercO","methO","nomethO")
colnames(sampEven)=c("chrE","startE","endE","methpercE","methE","nomethE")

sampOdd$sumO=sampOdd$methO+sampOdd$nomethO
sampEven$sumE=sampEven$methE+sampEven$nomethE

EvenOdd=cbind(sampOdd,sampEven)

EvenOdd$ratioOE=EvenOdd$sumO/EvenOdd$sumE
EvenOdd$ratioEO=EvenOdd$sumE/EvenOdd$sumO

ratio.25=subset(EvenOdd,ratioOE>.25 & ratioEO>.25)

ratio.25Odd=ratio.25[c(1:6)]
ratio.25Even=ratio.25[c(8:13)]

colnames(ratio.25Odd)=c("chr","start","end","methperc","meth","nometh")
colnames(ratio.25Even)=c("chr","start","end","methperc","meth","nometh")

all=rbind(ratio.25Odd,ratio.25Even)

all_order=all[with(all, order(chr, start)),]

write.table(all_order,paste0(sampname,".ratio25.txt"),col.names=F,row.names=F,quote=F,sep="\t")
