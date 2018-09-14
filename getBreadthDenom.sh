###################################
# 1. get bed file + sample 5hmc + gene name
# 2. uniq the bed file so you don't have duplicate bins
# do this as part of getBreadth.sh
###################################

###################################
# 3. only keep the rows that have non-zero 5hmc
###################################
for i in `seq 4 1 11`; do awk '{if($4!="NA"){print}}' all.conf.slim.noHead.txt.refGene.$i.uniq.bed > all.conf.slim.noHead.txt.refGene.$i.uniq.nonNA.bed; done


###################################
# 4. then just count per gene
###################################
for i in `seq 4 1 11`; do cut -f5 all.conf.slim.noHead.txt.refGene.$i.uniq.nonNA.bed |sort |  uniq -c > $i.nonNA.geneCounts.txt; done


###################################
# 5. tabulate and merge
###################################
for i in `seq 4 1 11`; do tail -n+2 $i.nonNA.geneCounts.txt | sed -e 's/ *//' -e 's/ /\t/' > $i.nonNa.geneCounts.tab; done


module load R
Rscript --vanilla merge.denom.R

