library(randomForest)
library(data.table)
library(ggplot2)
data = data.frame(fread("gene_max5hmC_ColNorm_transpose_noNA_noRowname.txt"))
data$class = c("T","T","T","T","T","T","N","N")
data$class = as.factor(data$class)

for (i in 1:10360){data[,i] = as.numeric (data[,i])}
breadth.RF = randomForest(data[,1:10360], data$class)
pdf("variableImportance_enhancer_mean.pdf")
varImpPlot(breadth.RF)
dev.off()
importance = data.frame(breadth.RF$importance)
featuresToKeep = rownames(subset(importance, MeanDecreaseGini > 0.014))
smallData = data[,featuresToKeep]
smallData$class = data$class
smallDataRF = randomForest(smallData[,1:6], smallData$class)
pdf("smallData.importance.enhancer_mean.pdf")
varImpPlot(smallDataRF)
dev.off()


featuresToKeep = c("")






pdf("sgip.breadth.pdf")
ggplot(smallData, aes(y=SGIP1_breadth5hmC, x=class)) + geom_boxplot() + theme_bw(20) dev.off()
