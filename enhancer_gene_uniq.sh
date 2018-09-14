samp=$1
hmc=$2

if [ "$hmc" == "hmc" ]; then

	egrep "enhancer" $samp | awk '{print $16}' | sort | uniq > $samp.gene_intermediate.txt
	join $samp.gene_intermediate.txt /projects/wei-lab/cfDNA/analysis/forPublication/tumorNorm/gene_enh_regions/gene_list.txt > $samp.geneEnh2.txt
	awk '{print $2}' $samp.geneEnh2.txt | sort | uniq > $samp.geneEnh.txt
	rm $samp.gene_intermediate.txt $samp.geneEnh2.txt

else

        egrep "enhancer" $samp | awk '{print $13}' | sort | uniq > $samp.gene_intermediate.txt
        join $samp.gene_intermediate.txt /projects/wei-lab/cfDNA/analysis/forPublication/tumorNorm/gene_enh_regions/gene_list.txt > $samp.geneEnh2.txt
        awk '{print $2}' $samp.geneEnh2.txt | sort | uniq > $samp.geneEnh.txt
        rm $samp.gene_intermediate.txt $samp.geneEnh2.txt

fi



