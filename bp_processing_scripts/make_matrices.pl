#make_matrices.pl

use warnings;

$fivep_file = $ARGV[0];
$out_dir = $ARGV[1];

open (FH, $fivep_file) or die $!;
while (<FH>){
	($id,$seq)=(split /\t/,$_); chomp $seq;
	$seq =~ tr/[a-z]/[A-Z]/;
	$id =~ /(\w+:\d+_\d+_[\+\-])/;
	#$id =~ /(.+)\([\+\-]\)/;
	$id = $1;
	$fhout = "$out_dir/$id.txt";
	open (FHout,">$fhout") or die $!;
	my @s;
	$seq =~ /(\w)(\w)(\w)(\w)(\w)(\w)/;
	$s[0] = $1; $s[1] = $2; $s[2] = $3;
	$s[3] = $4; $s[4] = $5; $s[5] = $6;
	#A
	print FHout "A";
	for (my $j = 0;$j<6;$j++){
		if ($s[$j] eq "A"){print FHout "\t1";}
		else {print FHout "\t0";}
	}
	print FHout "\n";
	#C
	print FHout "C";
	for (my $j = 0;$j<6;$j++){
		if ($s[$j] eq "C"){print FHout "\t1";}
		else {print FHout "\t0";}
	}
	print FHout "\n";
	#G
	print FHout "G";
	for (my $j = 0;$j<6;$j++){
		if ($s[$j] eq "G"){print FHout "\t1";}
		else {print FHout "\t0";}
	}
	print FHout "\n";
	#T
	print FHout "T";
	for (my $j = 0;$j<6;$j++){
		if ($s[$j] eq "T"){print FHout "\t1";}
		else {print FHout "\t0";}
	}
	print FHout "\n";
	#N
	print FHout "N";
	for (my $j = 0;$j<6;$j++){
		if ($s[$j] eq "N"){print FHout "\t1";}
		else {print FHout "\t0";}
	}
	print FHout "\n";
	close FHout;
}

