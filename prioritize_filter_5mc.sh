file=$1
coverageMin=$2
mcMin=$3
bin=$4 # can either be "Y" or anything else

if [ "$bin" == "Y" ]; then


	awk -v covMin=$coverageMin -v min=$mcMin '{if($6>=covMin && $7>=min){print $0}}'  $file > $file.filtered.cov${coverageMin}.mc${hmcMin}.bed

else

	awk -v covMin=$coverageMin -v min=$mcMin '{if(($7)>=covMin && $4>=min){print $0}}'  $file > $file.filtered.cov${coverageMin}.mc${hmcMin}.bed

fi


