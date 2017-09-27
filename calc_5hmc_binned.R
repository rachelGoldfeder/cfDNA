library(data.table)

#args = commandArgs(trailingOnly=TRUE)
#both<-fread(args[1])

for (i in c(1:22, 'X', 'Y')){
both<-fread(paste0("bis.oxbis.200window.", i,".txt"))


setDF(both)


attach(both)
ans=lapply(seq_along(V4), function(j) 
	prop.test(c(V4[j], V8[j]), c(V4[j] + V5[j], V8[j] + V9[j])))
detach (both)
	
pval = sapply(ans, '[[', 'p.value')
both$pval = pval
both$hmc = both$V4/(both$V4 + both$V5) - both$V8/(both$V9 + both$V8)

#n.tests = nrow(both)
#both.sig = both[both$pval<0.05/n.tests & both$hmc > 0, ]

both$sum = both$V4 + both$V5 + both$V9 + both$V8

both.sig = both[both$pval<0.05 & both$hmc > 0, ]


zeros = both[both$pval>=0.05 & !is.na(both$pval)  & both$sum>=20 ,]
zeros$hmc[zeros$hmc!=0] =0

conf =rbind(both.sig, zeros)

write.csv(both, file=paste0("all.",i,".csv"))
saveRDS(both.sig, file=paste0("significant.",i,".RData"))
write.csv(both.sig, file=paste0("significant.",i,".csv"))

write.csv(conf, file=paste0("confident.",i,".csv"))
}
