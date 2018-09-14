my %mapQ_hash;
my %chr_hash;
my %pair_chr_hash;
my %dist_hash;

while (my $line = <>) { 
	chomp( $line);
	my ($name, $flag, $chr, $pos, $mapQ, $cigar, $pair_chr, $pair_pos, $dist, @rest) = split("\t", $line);

	$mapQ_hash{$mapQ}++;
	$chr_hash{$chr}++;
	$pair_chr_hash{$pair_chr}++;
	if ($dist > 2000) {
		$dist = 2000;
	}
	if ($dist < -2000) {
		$dist = -2000 
	}

	$dist_hash{$dist}++;	

}





print "MapQ\n";
foreach my $key (sort (keys %mapQ_hash)){
        print "$key\t$mapQ_hash{$key}\n";
}

print "\n\nChr\n";
foreach my $key (sort (keys %chr_hash)){
        print "$key\t$chr_hash{$key}\n";
}

print "\n\nPair Chr\n";
foreach my $key (sort (keys %pair_chr_hash)){
        print "$key\t$pair_chr_hash{$key}\n";
}

print "\n\nDistance\n";
foreach my $key (sort (keys %dist_hash)){
        print "$key\t$dist_hash{$key}\n";
}



