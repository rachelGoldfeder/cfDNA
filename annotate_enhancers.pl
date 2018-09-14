#!/bin/perl
use warnings;

# USEAGE 
#
# perl annotate_enhancers.pl <geneList.bed> <enhancers.txt>
# gene list and enhancers list must be sorted by chr and pos
#
# Use this script to give each enhancer an assocated gene name based on which gene is closest
#
#

open (my $geneFile, '<', $ARGV[0])
	or die "Could not open file '$ARGV[0]' $!";

open (my $enhancerFile, '<', $ARGV[1])
	or die "Could not open file '$ARGV[1]' $!";


my %geneHash;
my %genePos;
while (my $geneLine = <$geneFile>){
	
	chomp ($geneLine);
	my ($geneChr, $geneStart, $geneEnd, $geneName) = split("\t", $geneLine);
	$geneHash{$geneChr}{$geneStart} = $geneName;	
	$genePos{$geneChr}{$geneStart} = $geneEnd;
}		



#  One line at a time, read in the enhancer list
while (my $enhancerLine = <$enhancerFile>){
	my $geneFound=0; # a flag to track overlapping gene and enhancer
	chomp ($enhancerLine);
	my ($enhancerChr, $enhancerStart, $enhancerEnd) = split("\t", $enhancerLine);
#	print "new enhancer!\n";

	
	# make an array to hold all edge positions of genes for this enhancer's chromosome
	my @positions;
	foreach my $k (keys %{$geneHash{$enhancerChr}}){
#		print "$k\n";
		push(@positions, $k);
		push(@positions, $genePos{$enhancerChr}{$k});
	}

#	print  join("\t",sort {$a <=> $b} @positions);
#	print "\n";



# get two closest genes:
# 1) the largest gene End that is smaller than Enhancer End
# 2) the smallest Start that is larger than Enhancer Start
# the above should also include overlapping genes -- only case it doesn't cover is the enhancer being entirely inside the gene, so need to check for that
# if enhancer start is bigger than gene start and enhancer end is smaller than gene end



	# if enhancer and gene overlap
	# then this gene is closest 
	foreach my $g (keys %{$genePos{$enhancerChr}}){
#		print "my g: $g\n";
		if( $enhancerStart >= $g && $enhancerEnd <= $genePos{$enhancerChr}{$g}){
#			print "THESE OVERLAP! $g $genePos{$enhancerChr}{$g}  $enhancerStart $enhancerEnd\n";
			print "$enhancerChr\t$enhancerStart\t$enhancerEnd\t$geneHash{$enhancerChr}{$g}\n";
			$geneFound=1;
			next;
		}
#		print "$g\n";
	}
	if($geneFound==1){
		next;
	}
	else{
		my $right_gene;
		my $left_gene; 
		# get the two closest genes as described above
		my $right = 10000000000 ; # smallest gene Start that is larger than enhancer start
		foreach my $gStart (keys %{$genePos{$enhancerChr}}){
			if($gStart >= $enhancerStart && $gStart < $right){
				$right_gene = $geneHash{$enhancerChr}{$gStart};	
				$right = $gStart;
			}
		}
		my $left = -100; # largest gene End that is smaller than enhancer end
		foreach my $gEnd (values %{$genePos{$enhancerChr}}){
			if ($gEnd <= $enhancerEnd && $gEnd > $left){
				foreach my $gStart (keys %{$genePos{$enhancerChr}}){
					if( $genePos{$enhancerChr}{$gStart} == $gEnd){
						$left_gene = $geneHash{$enhancerChr}{$gStart};
						$left = $gEnd;
					}
				}
			}	
		}

		# determine which is closest
		if (!($right==10000000000 && $left==-100)){		
		if(abs($enhancerStart - $left) <= abs($enhancerEnd - $right) && $left!=-100){
			print "$enhancerChr\t$enhancerStart\t$enhancerEnd\t$left_gene\n";

		}
		else{
			print "$enhancerChr\t$enhancerStart\t$enhancerEnd\t$right_gene\n";
		}
		}
		else {
			print STDERR "$enhancerChr\t$enhancerStart\t$enhancerEnd\tNO GENES FOR THIS CHR\n";
		}

	
	}	
}

