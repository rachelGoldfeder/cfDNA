library(data.table)


both<-fread("bis.oxbis.gene.txt")


setDF(both)


attach(both)
ans=lapply(seq_along(V2), function(j) 
	prop.test(c(V2[j], V4[j]), c(V2[j] + V3[j], V4[j] + V5[j])))
detach (both)
	
pval = sapply(ans, '[[', 'p.value')
both$pval = pval
both$hmc = both$V2/(both$V2 + both$V3) - both$V4/(both$V4 + both$V5)

#both$sum = both$V4 + both$V5 + both$V9 + both$V8

both.sig = both[both$pval<0.05 & both$hmc > 0, ]


zeros = both[both$pval>=0.05 & !is.na(both$pval) ,]
zeros$hmc[zeros$hmc!=0] =0

conf =rbind(both.sig, zeros)


write.csv(conf, file="confident.genes.csv",row.names=F, quote=F)
