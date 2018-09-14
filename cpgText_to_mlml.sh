cat $1 | awk -v OFS="\t" '{print $1,$2,$3,"CpG:"$7,$4/100,"+"}'  > $1.forMLML.txt 
