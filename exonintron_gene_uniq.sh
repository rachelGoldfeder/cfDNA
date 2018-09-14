samp=$1
hmc=$2

if [ "$hmc" == "hmc" ]; then

	egrep "exon|intron" $samp |awk '{print $16}'| sort | uniq > $samp.geneExonIntron.txt
	egrep "exon" $samp |awk '{print $16}'| sort | uniq  > $samp.geneExon.txt
	egrep "intron" $samp |awk '{print $16}'| sort | uniq  > $samp.geneIntron.txt

else

        egrep "exon|intron" $samp |awk '{print $13}'| sort | uniq > $samp.geneExonIntron.txt
        egrep "exon" $samp |awk '{print $13}'| sort | uniq  > $samp.geneExon.txt
        egrep "intron" $samp |awk '{print $13}'| sort | uniq  > $samp.geneIntron.txt

fi




