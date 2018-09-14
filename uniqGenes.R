args = commandArgs(trailingOnly=TRUE)

file1=read.table(args[1],header=F)
file2=read.table(args[2], header=F)


uniq1 = file1[!(file1$V1 %in% file2$V1),]
uniq2 = file2[!(file2$V1 %in% file1$V1),]
overlap = file2[(file2$V1 %in% file1$V1),]

write.table(file=paste0(args[1],".notIn.", args[2], ".txt"), uniq1, row.names=F, col.names=FALSE, quote=F)
write.table(file=paste0(args[2],".notIn.", args[1], ".txt"), uniq2, row.names=F, col.names=FALSE, quote=F)
write.table(file=paste0(args[2],".In.", args[1], ".txt"), overlap, row.names=F, col.names=FALSE, quote=F)

