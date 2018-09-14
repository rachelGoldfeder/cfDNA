file=$1
coverageMin=$2
hmcMin=$3




awk -v covMin=$coverageMin -v hMin=$hmcMin '{if(($5+$6)>=covMin && ($7+$8)>=covMin && $4>=hMin){print $0}}'  $file > $file.filtered.cov${coverageMin}.hmc${hmcMin}.bed



