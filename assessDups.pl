#!/usr/bin/perl

use strict; 
use warnings;

##############################################
# Rachel Goldfeder
# Aug 14, 2017
#
#
# Determine what proportion of duplicates marked by MarkDuplicates have the exact same sequence vs something slightly different
# Determine what proportion of duplicates marked by MarkDuplicates have multiple duplicates vs just 1
# 
#
#
# USEAGE: perl assessDups.pl <nonDups.sam> <dups.sam> <exactSeqMatch.hist> <numDups.hist>
#
#
# where nonDups.sam was made like so:
# samtools view -F 1024 <file.bam>  > nonDuplicateReads.sam
#
#
# and dups.sam was made like so:
#
#samtools view -f 1024 <file.bam>  > duplicateReads.sam
#
#
#############################################



open(my $nonDups_fh, '<', $ARGV[0])
	or die "Could not open file '$ARGV[0]' $!";


open(my $dups_fh, '<', $ARGV[1])
	or die "Could not open file '$ARGV[1]' $!";

open(my $exactSeqMatch_fh, '>', $ARGV[2])
	or die "Could not open file '$ARGV[2]' $!";

open(my $numDups_fh, '>', $ARGV[3])
	or die "Could not open file '$ARGV[3]' $!";

my %hash;


#############################################
#
# Read in entire file of non-duplicates and build up a hash
#
############################################ 
#build_hash($nonDups_fh);
print $numDups_fh "The non duplicates:\n";
print $numDups_fh "Number of sequences per position\tValue\n";
print $exactSeqMatch_fh "The non duplicates:\n";
print $exactSeqMatch_fh "Number of times each sequence is duplicated\tValue\n";
#run_stats(%hash);

#############################################
#
# Read in entire file of duplicates and add to hash
#
############################################ 
build_hash($dups_fh);
print $numDups_fh "\n\n\nNow with the duplicates added:\n";
print $numDups_fh "Number of sequences per position\tValue\n";
print $exactSeqMatch_fh "\n\n\nNow with the duplicates added:\n";
print $exactSeqMatch_fh "Number of times each sequence is duplicated\tValue\n";
run_stats(%hash);



my @proportions = calculateProportionOfDupsWithMatchingSeq(%hash);

print join("\n", @proportions);


sub calculateProportionOfDupsWithMatchingSeq {
	my (%h) = @_;
	my @prop_array;
	foreach my $chr (keys %h){
		foreach my $pos (keys %{$h{$chr}} ){	
			my $sum = 0.0;
			my $max = 0.0;
			foreach my $seq ( keys %{$h{$chr}{$pos}} ){
				$sum += $h{$chr}{$pos}{$seq};
				if ($h{$chr}{$pos}{$seq} > $max) { 
					$max = $h{$chr}{$pos}{$seq};
				}
			}
			if ($sum>1){
				my $prop = $max / $sum;
				push (@prop_array, $prop);
			}
		}
	}

	return @prop_array;
}








sub build_hash {
	my ($fh) = @_;

	while (my $line = <$fh>) {
		chomp $line;
		my @a = split("\t", $line); # a[2] = chrom, a[3] = pos, a[9] = sequence

		if (defined($hash{$a[2]}{$a[3]}{$a[9]})){
			$hash{$a[2]}{$a[3]}{$a[9]}++;
		} 
		else {
			$hash{$a[2]}{$a[3]}{$a[9]} = 1;

		}
	}
}



sub run_stats {
	my (%h) = @_;
	my %stats_hash;
	my %stats_hash_EM;
	foreach my $chr (keys %h){
		foreach my $pos (keys %{$h{$chr}} ){
			my $num_keys = scalar keys %{$h{$chr}{$pos}};
			if (defined ($stats_hash{$num_keys})){
				$stats_hash{$num_keys}++;		
			}
			else {
				$stats_hash{$num_keys}=1;
			}
			foreach my $seq ( keys %{$h{$chr}{$pos}} ){
				if (defined ( $stats_hash_EM{$h{$chr}{$pos}{$seq}})){
					$stats_hash_EM{$h{$chr}{$pos}{$seq}}++;	
				}
				else {
					 $stats_hash_EM{$h{$chr}{$pos}{$seq}} = 1;
				}
	
			}


		}	
	}

	foreach my $key (sort { $a <=> $b } ( keys %stats_hash )) {
		print $numDups_fh "$key\t$stats_hash{$key}\n";
	}

	foreach my $k (sort { $a <=> $b } ( keys %stats_hash_EM )) {
        	print $exactSeqMatch_fh "$k\t$stats_hash_EM{$k}\n";
	}



}












