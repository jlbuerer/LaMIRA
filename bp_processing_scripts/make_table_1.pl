use warnings;

$bp_dir = $ARGV[0];
open (FH,"$bp_dir/BPs_apparent_real_wFoundFiles_final.txt") or die $!;

my %branchpoint;

while (<FH>){
	($app,$motif,$real,$seq,$found,$numreads,$uniqreads,$mutreads,$mutuniqreads)=(split /\t/,$_); chomp $mutuniqreads;
	$app =~ /(\w+):(\d+)_([+-])/;
	$chrom = $1; $appnt = $2; $strand = $3;
	unless ($real eq "null"){
		$dist = abs($appnt-$real);}
	else {
		$dist = 0; $real = $appnt;
	}
	$id = $chrom."\t".$real."\t".$strand."\t".$motif;
	@list = (split /\,/,$found);

	if (exists $branchpoint{$id}{"read"}{$dist}){
		$branchpoint{$id}{"read"}{$dist}=$branchpoint{$id}{$dist}+$numreads;
	}
	else {$branchpoint{$id}{"read"}{$dist}=$numreads;}

	if (exists $branchpoint{$id}{"readuniq"}{$dist}){
		$branchpoint{$id}{"readuniq"}{$dist}=$branchpoint{$id}{$dist}+$uniqreads;
	}
	else {$branchpoint{$id}{"readuniq"}{$dist}=$uniqreads;}

	if (exists $branchpoint{$id}{"mutread"}{$dist}){
		$branchpoint{$id}{"mutread"}{$dist}=$branchpoint{$id}{$dist}+$mutreads;
	}
	else {$branchpoint{$id}{"mutread"}{$dist}=$mutreads;}

	if (exists $branchpoint{$id}{"mutreaduniq"}{$dist}){
		$branchpoint{$id}{"mutreaduniq"}{$dist}=$branchpoint{$id}{$dist}+$mutuniqreads;
	}
	else {$branchpoint{$id}{"mutreaduniq"}{$dist}=$mutuniqreads;}

	foreach $a (@list){
		if ($a =~ /\w+/){
			$a =~ /(.+)\((\d+)\;(\d+)\)/;
			$one = $1; $two = $2; $three = $3;
			$anew = $one."(".$appnt.";".$two.";".$three.")";
			$branchpoint{$id}{"found"}{$anew}=1;
		}
	}
	$branchpoint{$id}{"seq"}=$seq;
}

foreach my $bp (keys %branchpoint){
	print $bp,"\t",$branchpoint{$bp}{"seq"},"\t";
	if (exists $branchpoint{$bp}{"read"}{5}){print $branchpoint{$bp}{"read"}{5},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"read"}{4}){print $branchpoint{$bp}{"read"}{4},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"read"}{3}){print $branchpoint{$bp}{"read"}{3},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"read"}{2}){print $branchpoint{$bp}{"read"}{2},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"read"}{1}){print $branchpoint{$bp}{"read"}{1},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"read"}{0}){print $branchpoint{$bp}{"read"}{0},"\t";}
	else {print "0\t";}

	if (exists $branchpoint{$bp}{"readuniq"}{5}){print $branchpoint{$bp}{"readuniq"}{5},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"readuniq"}{4}){print $branchpoint{$bp}{"readuniq"}{4},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"readuniq"}{3}){print $branchpoint{$bp}{"readuniq"}{3},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"readuniq"}{2}){print $branchpoint{$bp}{"readuniq"}{2},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"readuniq"}{1}){print $branchpoint{$bp}{"readuniq"}{1},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"readuniq"}{0}){print $branchpoint{$bp}{"readuniq"}{0},"\t";}
	else {print "0\t";}

	if (exists $branchpoint{$bp}{"mutread"}{5}){print $branchpoint{$bp}{"mutread"}{5},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutread"}{4}){print $branchpoint{$bp}{"mutread"}{4},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutread"}{3}){print $branchpoint{$bp}{"mutread"}{3},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutread"}{2}){print $branchpoint{$bp}{"mutread"}{2},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutread"}{1}){print $branchpoint{$bp}{"mutread"}{1},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutread"}{0}){print $branchpoint{$bp}{"mutread"}{0},"\t";}
	else {print "0\t";}

	if (exists $branchpoint{$bp}{"mutreaduniq"}{5}){print $branchpoint{$bp}{"mutreaduniq"}{5},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutreaduniq"}{4}){print $branchpoint{$bp}{"mutreaduniq"}{4},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutreaduniq"}{3}){print $branchpoint{$bp}{"mutreaduniq"}{3},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutreaduniq"}{2}){print $branchpoint{$bp}{"mutreaduniq"}{2},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutreaduniq"}{1}){print $branchpoint{$bp}{"mutreaduniq"}{1},",";}
	else {print "0,";}
	if (exists $branchpoint{$bp}{"mutreaduniq"}{0}){print $branchpoint{$bp}{"mutreaduniq"}{0},"\t";}
	else {print "0\t";}




	foreach my $source (keys %{$branchpoint{$bp}{"found"}}){
		print $source,",";
	}
	print "\n";
}
