##############################################
# Identify marker locations that are helpful for distinguishing various cancers from each other and/or that remain consistent in cfDNA vs tumor
# Rachel Goldfeder
# September 26, 2017
##############################################

# Libraries
library(data.table)



#############################################
# 0. Get confident values for 5hmc and 5mc  for individual datasets
#############################################
# for 5hmc this comes from the confident.$i.csv files
# require 
# for 5mc, do this here


get_conf_5mc<-function(oxbs_file, threshold, name){

	# read in text file with counts of methylated and non methylated
	data.ox = fread(oxbs_file)

	# sum the two columns
	data.ox$sum = data.ox$V5 + data.ox$V6	

	# if the sum is greater than 8 (or some threshold, the user can set), keep those rows 
	conf = data.ox [data.ox$sum >= threshold, ]
	
	write.csv (conf, file=paste0("confident_5mc.", name ,".csv"))
	return (conf)


}


#############################################
# 1. require overlap for reps to be within a particular range
#############################################

# rep 1 and rep2 must have a unique column called pos to join on and also must have an mc column with values ranging from 0 to 100.
check_reps_for_similarity<-function(rep1, rep2,  sim.thresh){
	merged = merge(rep1, rep2, by="pos")
	merged$abs.diff = abs(merged$mc.x - merged$mc.y)
	similar = merged[merged$abs.diff < sim.thresh,]

	return (similar)

}



#############################################
# 2. Build a matrix where each row is a bin
# and each cell is a confident
#############################################


buildMatrix<-function(m, add){

	m.new = merge(m, add, by="pos")
	return (m.new)
}





#############################################
# Main code body
#############################################

# read in commandline Args
# TODO: Consider changing this to be a YAML file

args = commandArgs(trailingOnly=TRUE)
fileList = args[1]

ox.threshold = 8
# TODO: user can set this threshold, but the default is 8.
#ox.threshold = args[2]

# for each input file, get conf 5mc
fiveMC = list()
for (i in 1:length(fileList)){
	name = fileList[[i]] # TODO, make sure this works depending on how the file naming works
	fiveMC[[i]] = get_conf_5mc(fileList[[i]], ox.threshold, name)
}

# rep 1 and rep2 must have a unique column called pos to join on and also must have an mc column with values ranging from 0 to 100.
sim_5mc = check_reps_for_similarity(rep1_mc, rep2_mc, sim.thresh)
sim_5hmc = check_reps_for_similarity(rep1_hmc, rep2_hmc, sim.thresh)


# now, build up a df with the bins that have confident info in all
mat = sim5mc

mat = buildMatrix(mat, sim5hmc)
mat = buildMatrix(mat,) #TODO








#=================================================================================


# read in 5mc data

# TODO - separatate by chrom before reading it in and bin

# get confident 5mc data	
ox.threshold = 8
	
conf.5mc.norm1 = get_conf_5mc ("/projects/wei-lab/cfDNA/analysis/testSet/Adult_Brain_OxBis_1.fastq.gz.2M.oxbis.sort.mDups_CpG.bedGraph", ox.threshold, "test.ox.norm1.")
conf.5mc.norm2 = get_conf_5mc ("/projects/wei-lab/cfDNA/analysis/testSet/Adult_Brain_OxBis_1.fastq.gz.2M.oxbis.sort.mDups_CpG.bedGraph", ox.threshold, paste0("test.ox.norm2.", i))
	

for (i in c(1:22, 'X', 'Y')){

	# read in 5hmc data
	conf.5hmc.norm1 = read.table(paste0("/projects/wei-lab/cfDNA/analysis/testSet/confident.",i,".csv"))
	conf.5hmc.norm2 = read.table(paste0("/projects/wei-lab/cfDNA/analysis/testSet/confident.",i,".csv"))

	conf.5hmc.cancer1 = read.table(paste0("/projects/wei-lab/cfDNA/analysis/testSet/confident.",i,".csv"))
	conf.5hmc.cancer2 = read.table(paste0("/projects/wei-lab/cfDNA/analysis/testSet/confident.",i,".csv"))
	
	# check 5hmc reps for similarity
	sim.thresh=25
	
	normal.similar.5hmc = check_reps_for_similarity(conf.5hmc.norm1, conf.5hmc.norm2,  sim.thresh){
	cancer.similar.5hmc = check_reps_for_similarity(conf.5hmc.cancer1, conf.5hmc.cancer2,  sim.thresh){

	




}





