four = read.table("4.geneCounts.tab")
five = read.table("5.geneCounts.tab")
six = read.table("6.geneCounts.tab")
seven = read.table("7.geneCounts.tab")
eight = read.table("8.geneCounts.tab")
nine = read.table("9.geneCounts.tab")
ten = read.table("10.geneCounts.tab")
eleven = read.table("11.geneCounts.tab")


four.NA = read.table("4.nonNa.geneCounts.tab")
five.NA = read.table("5.nonNa.geneCounts.tab")
six.NA = read.table("6.nonNa.geneCounts.tab")
seven.NA = read.table("7.nonNa.geneCounts.tab")
eight.NA = read.table("8.nonNa.geneCounts.tab")
nine.NA = read.table("9.nonNa.geneCounts.tab")
ten.NA = read.table("10.nonNa.geneCounts.tab")
eleven.NA = read.table("11.nonNa.geneCounts.tab")





denom = merge(four, four.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered")
denom$colon4_breadth = denom$colon4_5hmC / denom$colon4_covered
denom$colon4_breadth[!is.na(denom$colon4_covered) & is.na(denom$colon4_5hmC)] = 0
denom$colon4_5hmC[is.na(denom$colon4_5hmC)] = 0




denom = merge (denom, five, by="V2", all=TRUE) 
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered","colon4_breadth" , "colon8_5hmC")

denom = merge (denom, five.NA, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered")

denom$colon8_breadth = denom$colon8_5hmC / denom$colon8_covered
denom$colon8_breadth[!is.na(denom$colon8_covered) & is.na(denom$colon8_5hmC)] = 0
denom$colon8_5hmC[is.na(denom$colon8_5hmC)] = 0





denom = merge (denom, six, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered", "colon8_breadth", "colon11_5hmC")

denom = merge (denom, six.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered", "colon8_breadth", "colon11_5hmC", "colon11_covered")

denom$colon11_breadth = denom$colon11_5hmC / denom$colon11_covered
denom$colon11_breadth[!is.na(denom$colon11_covered) & is.na(denom$colon11_5hmC)] = 0
denom$colon11_5hmC[is.na(denom$colon11_5hmC)] = 0





denom = merge (denom, seven, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered", "colon8_breadth", "colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC")

denom = merge (denom, seven.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered")

denom$colon1_breadth = denom$colon1_5hmC / denom$colon1_covered
denom$colon1_breadth[!is.na(denom$colon1_covered) & is.na(denom$colon1_5hmC)] = 0
denom$colon1_5hmC[is.na(denom$colon1_5hmC)] = 0





denom = merge (denom, eight, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered", "colon8_breadth", "colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC")

denom = merge (denom, eight.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered")


denom$colon5_breadth = denom$colon5_5hmC / denom$colon5_covered
denom$colon5_breadth[!is.na(denom$colon5_covered) & is.na(denom$colon5_5hmC)] = 0
denom$colon5_5hmC[is.na(denom$colon5_5hmC)] = 0





denom = merge (denom, nine, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC")

denom = merge (denom, nine.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC", "colon31_covered")

denom$colon31_breadth = denom$colon31_5hmC / denom$colon31_covered

denom$colon31_breadth[!is.na(denom$colon31_covered) & is.na(denom$colon31_5hmC)] = 0
denom$colon31_5hmC[is.na(denom$colon31_5hmC)] = 0



denom = merge (denom, ten, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered", "colon8_breadth", "colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC", "colon31_covered", "colon31_breadth", "norm2_5hmC")

denom = merge (denom, ten.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC", "colon31_covered", "colon31_breadth", "norm2_5hmC", "norm2_covered")

denom$norm2_breadth = denom$norm2_5hmC / denom$norm2_covered
denom$norm2_breadth[!is.na(denom$norm2_covered) & is.na(denom$norm2_5hmC)] = 0

denom$norm2_5hmC[is.na(denom$norm2_5hmC)] = 0


denom = merge (denom, eleven, by="V2", all=TRUE)          
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC", "colon31_covered", "colon31_breadth", "norm2_5hmC", "norm2_covered", "norm2_breadth", "norm3_5hmC")

denom = merge (denom, eleven.NA, by="V2", all=TRUE)
colnames(denom) = c("V2","colon4_5hmC", "colon4_covered", "colon4_breadth","colon8_5hmC" , "colon8_covered",  "colon8_breadth","colon11_5hmC", "colon11_covered", "colon11_breadth", "colon1_5hmC", "colon1_covered", "colon1_breadth", "colon5_5hmC", "colon5_covered", "colon5_breadth", "colon31_5hmC", "colon31_covered", "colon31_breadth", "norm2_5hmC", "norm2_covered", "norm2_breadth", "norm3_5hmC", "norm3_covered")

denom$norm3_breadth = denom$norm3_5hmC / denom$norm3_covered
denom$norm3_breadth[!is.na(denom$norm3_covered) & is.na(denom$norm3_5hmC)] = 0
denom$norm3_5hmC[is.na(denom$norm3_5hmC)] = 0







#denom[is.na(denom)] = 0


write.table(denom,"genes.breadth.Denom.merge.txt", row.names=F, quote=F, sep="\t")
