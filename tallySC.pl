 
#my $filename = $ARGV[0];
#open(my $fh, '<', $filename)
#  or die "Could not open file '$filename' $!";
 

my %sc_hash;
my $sc_ct=0;
my $no_sc_ct=0;
while (my $line = <>){
	chomp ($line);
	my @a = split ("\t", $line);
	my $size = @a;
	if ($size<4){
		next;
	}
	else {
		my $cigar = @a[5];
		if ($cigar =~/S/){
			# count number of reads with softclipping
			$sc_ct++;

			# for the reads with softclipping, how many bases are clipped?
			# S will either be at the beginning or end. So, I can split by "S"	
			my @splitCigar = split ("S", $cigar);
			if (@splitCigar[0]=~/[a-zA-Z]/){
			# this means that there were other cigar types before the softclipping, so SC was at the end only			
							
				my @splitBegCigar = split(/[MDIH]/, (@splitCigar[0]));
				my $numEndSC =  @splitBegCigar[-1];
				$sc_hash{$numEndSC}++;
			}
			
			else {
			# soft clipping is either only at the start or at the start and end
				if (@splitCigar[-1]!~/[a-zA-Z]/) {	
				# softclipping is at the end 
					my @splitEndCigar = split(/[MDIH]/, (@splitCigar[0]));
                                	my $numEndSC =  @splitEndCigar[-1];				
	                        	$sc_hash{$numEndSC}++;


				}
				# get the softclipping at the start:
				$sc_hash{@splitCigar[0]}++;

			}

			
		}
		else {

			# count number of reads with no softclipping
			$no_sc_ct++;

		}



	}	 

}



### Print all the things

print "Number of reads with softclipping\n";
print "$sc_ct\n\n";

print "Number of reads without softclipping\n";
print "$no_sc_ct\n\n"; 


foreach my $key (sort (keys %sc_hash)){
	print "$key\t$sc_hash{$key}\n";
}


