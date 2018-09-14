my %hash;



#sort  -k7,7nr  refGeneParts.locs.txt | perl thisScript.pl 
#### need to read in other file
## determine which transcript to keep (longest one)
#Then also label all unlabeled positions as intergenic

while (my $line = <>){
	chomp($line);
	my @a = split("\t", $line);
	if (!defined($hash{$a[5]}) || (defined($hash{$a[5]}) && $hash{$a[5]} eq $a[4])){
		$hash{$a[5]}=$a[4];	
		print "$line\n";	
	}
	
}



