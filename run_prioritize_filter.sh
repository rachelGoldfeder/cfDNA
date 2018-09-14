file=$1

for covMin in `seq 1 1 25`
do
for hmcMin in `seq 0 0.05 1`
do
sh /projects/wei-lab/cfDNA/analysis/scripts/prioritize_filter.sh $file $covMin $hmcMin
done
done
