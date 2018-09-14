file=$1

awk '{if ($4 != 0){print}}' $file | wc -l > $file.totalMeth.count

awk '{sum+=$5} END {print sum}' $file > $file.totalMeth.txt
awk '{sum+=$6} END {print sum}' $file > $file.totalNotMeth.txt




