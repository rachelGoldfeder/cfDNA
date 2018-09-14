# run this program for each chromosome
# probably with a lot of memory
#
#
# perl thisProgram.pl perChr_File


open(my $fh, '<', $ARGV[0])
  or die "Could not open file '$ARGV[0]' $!";


my %hash;
my $chr;


while (my $line = <$fh>) {
	chomp $line;
	my @a = split("\t", $line);
	$chr=$a[0];
	for (my $i=$a[1]; $i<$a[2]; $i++){
		my @typeArray;
		if(defined($hash{$i})){
			$tArray = $hash{$i};
			push (@typeArray, @$tArray);
		}
		push (@typeArray, $a[3]);
		$hash{$i}= [@typeArray];
	}
}
 foreach my $k (sort(keys %hash)) {
	$arr = $hash{$k};
	my @l = @$arr;
	my $end = $k + 1;
	if($#l > 0){
			if (grep(/promoter/, @l)){
				print "$chr\t$k\t$end\tpromoter\n";
			}
			elsif(grep(/exon/, @l)){
				print "$chr\t$k\t$end\texon\n";
			}
                        elsif(grep(/intron/, @l)){
                               print "$chr\t$k\t$end\tintron\n";
                        }
			else{
                               print "$chr\t$k\t$end\tintergenic\n";
                        }
	}
	else{
		print "$chr\t$k\t$end\t@l\n";
	}
}
