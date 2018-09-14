#!/bin/perl
# turn refGene into something more useable
# February 8, 2018
# Rachel Goldfeder

#USEAGE:
# zcat refGene.txt.gz | perl refGene2txt.pl > refGeneParts.locs.txt

# Want:
# 1) chr
# 2) start
# 3) stop
# 4) type
# 5) name
# 6) name2

my $header = <>;
while (my $line = <>){

	chomp($line);
	my ($bin, $name, $chrom, $strand, $txStart, $txEnd, $cdsStart, $cdsEnd, 
		$exonCount, $exonStarts, $exonEnds, $score, $name2, $cdsStartStat, 
		$cdsEndStat, $exonFrames) = split("\t", $line);
	if ($name  !~/^NM/){
		next;
	}

	my @exStarts = split(",", $exonStarts);
	my @exEnds = split(",", $exonEnds);
	my $prevStop;
	my $trancriptSize = $txEnd - $txStart;
	
	for (my $i=0; $i<$exonCount; $i++){
		my $start = $exStarts[$i];
		my $stop = $exEnds[$i];
		my $type = "exon";
		if ($i!=0){
			my $intronStart = $prevStop;
			my $intronEnd = $start;
			print join("\t", $chrom, $intronStart, $intronEnd, "intron", $name, $name2, $trancriptSize, $strand);
                	print "\n";
		}
		print join("\t", $chrom, $start, $stop, $type, $name, $name2, $trancriptSize, $strand);
		print "\n";
		$prevStop = $stop;

	}

	if ($strand == "+"){
		my $promoterStart = $txStart - 2500;
		my $promoterEnd = $txStart;
		print join("\t", $chrom, $promoterStart, $promoterEnd, "promoter", $name, $name2, $trancriptSize, $strand);
               	print "\n";
	}
	else{
		my $promoterStart = $txEnd + 2500;
		my $promoterEnd = $txEnd;
		print join("\t", $chrom, $promoterStart, $promoterEnd, "promoter", $name, $name2, $trancriptSize, $strand);
               	print "\n";

	}






}



