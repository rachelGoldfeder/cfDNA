cat $1 | awk '{print $0"\t"($5/($7) - $8/($10))* 100"\t"$7+$10"\t"($7+$10)/2}' > $1.fullData.txt
