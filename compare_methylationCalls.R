###########################################
# Compare Methylation Calls
# Rachel Goldfeder
# Aug 22, 2017
##########################################

library (data.table)
library (ggplot2)



f2 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3/BS-norm-cfDNA-3.mcall.bdg") # 3bp required to trimming
f1 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3_R1_val_1.fq.gz/BS-norm-cfDNA-3_R1_val_1.fq.gz.mcall.bdg")#1 bp required to trim
setDF(f1)
setDF(f2)

summary.ct=list()
summary.perc=list()
for (i in c(1:22)){
	f1.sub = subset(f1, V1 == i)
	f2.sub = subset(f2, V1== i)
	data = merge(f1.sub, f2.sub, by=c("V2"))

	diff.count = data$V5.x - data$V5.y
	diff.perc = data$V4.x - data$V4.y
	summary.ct[[i]] = diff.count
	summary.perc[[i]] = diff.perc
}


counts = as.data.frame(unlist(summary.ct))
counts$Temp =rep ("grch38-PA\n1bp match\nvs\n3bp match", nrow(counts))
counts$location=rep("grch38-PA\n1bp match\nvs\n3bp match\nCpGs", nrow(counts))
colnames(counts)=c("DeltaCounts", "Temp", "location")
percents = as.data.frame(unlist(summary.perc))
percents$Temp =rep ("grch38-PA\n1bp match\nvs\n3bp match", nrow(percents))
percents$location=rep("grch38-PA\n1bp match\nvs\n3bp match\nCpGs", nrow(percents))
colnames(percents)=c("DeltaPercentage", "Temp", "location")


print(c("Number of grch38-PA CpG positions with a change in methylation status" ))
print(sum(counts$DeltaCounts>0))
print(c("out of:"))
print(nrow(counts))








f3 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch37/BS-norm-cfDNA-3_R1_val_1.fq.gz/BS-norm-cfDNA-3_R1_val_1.fq.gz.mcall.bdg") #1bp trimmed
f4 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch37/BS-norm-cfDNA-3/BS-norm-cfDNA-3.mcall.bdg") # not trimmed
setDF(f3)
setDF(f4)

summary.ct2=list()
summary.perc2=list()
for (i in c(1:22)){
        f1.sub = subset(f3, V1 == i)
        f2.sub = subset(f4, V1== i)
        data = merge(f1.sub, f2.sub, by=c("V2"))

        diff.count = data$V5.x - data$V5.y
        diff.perc = data$V4.x - data$V4.y
        summary.ct2[[i]] = diff.count
        summary.perc2[[i]] = diff.perc
}


counts2 = as.data.frame(unlist(summary.ct2))
counts2$Temp =rep ("grch37\nNo trimming\nvs\n1bp match", nrow(counts2))
counts2$location=rep("grch37\nNo trimming\nvs\n1bp match\nCpGs", nrow(counts2))
colnames(counts2)=c("DeltaCounts", "Temp", "location")
percents2 = as.data.frame(unlist(summary.perc2))
percents2$Temp =rep ("grch37\nNo trimming\nvs\n1bp match", nrow(percents2))
percents2$location=rep("grch37\nNo trimming\nvs\n1bp match\nCpGs", nrow(percents2))
colnames(percents2)=c("DeltaPercentage", "Temp", "location")


print(c("Number of grch37 CpG positions with a change in methylation status" ))
print(sum(counts2$DeltaCounts>0))
print(c("out of:"))
print(nrow(counts2))


counts_tot = rbind(counts, counts2)
percents_tot = rbind(percents, percents2)






f5 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch37/BS-norm-cfDNA-3_R1_val_1.fq.gz/BS-norm-cfDNA-3_R1_val_1.fq.gz.mcall.all.bdg")
f6 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch37/BS-norm-cfDNA-3/BS-norm-cfDNA-3.mcall.all.bdg")
setDF(f5)
setDF(f6)

summary.ct2=list()
summary.perc2=list()
for (i in 22){
        f1.sub = subset(f5, V1 == i)
        f2.sub = subset(f6, V1== i)
        data = merge(f1.sub, f2.sub, by=c("V2"))

        diff.count = data$V5.x - data$V5.y
        diff.perc = data$V4.x - data$V4.y
        summary.ct2[[i]] = diff.count
        summary.perc2[[i]] = diff.perc
}


counts2 = as.data.frame(unlist(summary.ct2))
counts2$Temp =rep ("grch37\nNo trimming\nvs\n1bp match", nrow(counts2))
counts2$location=rep("grch37\nNo trimming\nvs\n1bp match\nAll", nrow(counts2))
colnames(counts2)=c("DeltaCounts", "Temp", "location")
percents2 = as.data.frame(unlist(summary.perc2))
percents2$Temp =rep ("grch37\nNo trimming\nvs\n1bp match", nrow(percents2))
percents2$location=rep("grch37\nNo trimming\nvs\n1bp match\nAll", nrow(percents2))
colnames(percents2)=c("DeltaPercentage", "Temp", "location")


print(c("Number of grch37 positions with a change in methylation status" ))
print(sum(counts2$DeltaCounts>0))
print(c("out of:"))
print(nrow(counts2))


counts_tot = rbind(counts_tot, counts2)
percents_tot = rbind(percents_tot, percents2)






















f8 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3/BS-norm-cfDNA-3.mcall.all.bdg")
setDF(f1)
f7 = fread("/projects/wei-lab/cfDNA/analysis/firstSet/align_hg19/grch38_primarySeq/BS-norm-cfDNA-3_R1_val_1.fq.gz/BS-norm-cfDNA-3_R1_val_1.fq.gz.mcall.all.bdg")
setDF(f2)

summary.ct=list()
summary.perc=list()
for (i in 22){
        f1.sub = subset(f7, V1 == i)
        f2.sub = subset(f8, V1== i)
        data = merge(f1.sub, f2.sub, by=c("V2"))

        diff.count = data$V5.x - data$V5.y
        diff.perc = data$V4.x - data$V4.y
        summary.ct[[i]] = diff.count
        summary.perc[[i]] = diff.perc
}


counts = as.data.frame(unlist(summary.ct))
counts$Temp =rep ("grch38-PA\n1bp match\nvs\n3bp match", nrow(counts))
counts$location=rep("grch38-PA\n1bp match\nvs\n3bp match\nAll", nrow(counts))
colnames(counts)=c("DeltaCounts", "Temp", "location")
percents = as.data.frame(unlist(summary.perc))
percents$Temp =rep ("grch38-PA\n1bp match\nvs\n3bp match", nrow(percents))
percents$location=rep("grch38-PA\n1bp match\nvs\n3bp match\nAll", nrow(percents))
colnames(percents)=c("DeltaPercentage", "Temp", "location")

print(c("Number of grch38-PA positions with a change in methylation status" ))
print(sum(counts$DeltaCounts>0))
print(c("out of:"))
print(nrow(counts))


counts_tot = rbind(counts_tot, counts)
percents_tot = rbind(percents_tot, percents)






png("counts.png", width=800)
ggplot(counts_tot, aes(x = location,y=DeltaCounts)) + geom_violin(aes(col=Temp)) + theme_bw(20) + xlab("\nDataset") + ylab("Change in\nnumber of reads\nshowing methylation\n") + guides(col=F) 
dev.off()

png("percentages.png", width=800)
ggplot(percents_tot, aes(x = location, y=DeltaPercentage)) + geom_violin(aes(col=Temp)) + theme_bw(20)  + xlab("\nDataset") + ylab("Change in\npercentage of reads\nshowing methylation\n") +guides(col=F)
dev.off()






changed_counts = counts_tot[counts_tot$DeltaCounts!=0,]
changed_percent = percents_tot[percents_tot$DeltaPercentage!=0,]

png("counts_nonZero.png", width=800)
ggplot(changed_counts, aes(x = location,y=DeltaCounts)) + geom_violin(aes(col=Temp)) + theme_bw(20) + xlab("\nDataset") + ylab("Change in\nnumber of reads\nshowing methylation\n") + guides(col=F)
dev.off()

png("percentages_nonZero.png", width=800)
ggplot(changed_percent, aes(x = location, y=DeltaPercentage)) + geom_violin(aes(col=Temp)) + theme_bw(20)  + xlab("\nDataset") + ylab("Change in\npercentage of reads\nshowing methylation\n") +guides(col=F)
dev.off()





