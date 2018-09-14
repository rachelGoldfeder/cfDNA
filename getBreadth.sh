###################################
# 1. get bed file + sample 5hmc + gene name
###################################

#for i in `seq 4 1 11`; do echo " cut -f1-3,${i},17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.$i.bed"; done
cut -f1-3,4,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.4.bed
cut -f1-3,5,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.5.bed
cut -f1-3,6,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.6.bed
cut -f1-3,7,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.7.bed
cut -f1-3,8,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.8.bed
cut -f1-3,9,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.9.bed
cut -f1-3,10,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.10.bed
cut -f1-3,11,17 all.conf.slim.noHead.txt.refGene.bed > all.conf.slim.noHead.txt.refGene.11.bed


###################################
# 2. uniq the bed file so you don't have duplicate bins
###################################
for i in `seq 4 1 11`; do sort all.conf.slim.noHead.txt.refGene.$i.bed  | uniq > all.conf.slim.noHead.txt.refGene.$i.uniq.bed; done

###################################
# 3. only keep the rows that have non-zero 5hmc
###################################
for i in `seq 4 1 11`; do awk '{if($4!="NA" && $4 !=0){print}}' all.conf.slim.noHead.txt.refGene.$i.uniq.bed > all.conf.slim.noHead.txt.refGene.$i.uniq.nonZero.bed; done


###################################
# 4. then just count per gene
###################################
for i in `seq 4 1 11`; do cut -f5 all.conf.slim.noHead.txt.refGene.$i.uniq.nonZero.bed |sort |  uniq -c > $i.geneCounts.txt; done


###################################
# 5. tabulate and merge
###################################
for i in `seq 4 1 11`; do tail -n+2 $i.geneCounts.txt | sed -e 's/ *//' -e 's/ /\t/' > $i.geneCounts.tab; done


module load R
Rscript --vanilla merge.R

