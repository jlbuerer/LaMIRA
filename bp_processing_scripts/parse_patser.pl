#parse_patser.pl

use warnings;

my %data;

$numargs = $#ARGV;
open(FHout, ">output.txt") or die $!;
for (my $j = 0; $j<=$numargs;$j++){
	$ARGV[$j] =~ /uniq_seq_(.+)_scores.txt/;
	$motif = $1;
	print FHout "$ARGV[$j]\n";
	print FHout "$motif\n";
	$pos_low = 0; $pos_high = 0;
	if (($motif eq "canonical")||($motif eq "canonicalCbp")){
		$pos_low = 5; $pos_high = 7;
	}
	elsif ($motif eq "2ntbulge"){
		$pos_low = 4; $pos_high = 7;
	}
	elsif ($motif eq "firstTRY_1bulge"){
		$pos_low = 8; $pos_high = 10;
	}
	elsif ($motif eq "firstTRY_2bulge"){
		$pos_low = 7; $pos_high = 10;
	}
	elsif ($motif eq "firstTRY_3bulge"){
		$pos_low = 6; $pos_high = 10;
	}
	#print $category,"\t",$motif,"\n";
	open (FH,$ARGV[$j]) or die $!;
	while (<FH>){
		if ($_ =~ /position/){
			if ($_ =~ /^(.+)\s+position\=\s+(\d+).+score=\s+(-?\d+\.?\d*)\s+.*value\)\=\s+(-?\d+\.?\d*)\s+sequence=\s+([ACGT]+)/){
				$locus = $1;
				$position = $2;
				$score = $3;$lnp = $4;
				$seq = $5;
				if (($position >=$pos_low)&&($position <=$pos_high)){
					if ((exists $data{$locus}{$motif})&&($data{$locus}{$motif}=~ /\d+/)){
						$score2 = (split /\t/,$data{$locus}{$motif})[2];
						if ($score > $score2){
							$data{$locus}{$motif} = $position."\t".$seq."\t".$score."\t".$lnp;
						}
					}
					else {
						$data{$locus}{$motif}=$position."\t".$seq."\t".$score."\t".$lnp;
					}
				}
				else {$data{$locus}{$motif}="\t\t\t";}
			}
			else {
				print "error: $_";
			}
		}
	}
	close FH;
}

print "loci\tcanonical\t\t\t\tcanonicalCbp\t\t\t\t2ntbulge\t\t\t\tfirstTRY_1bulge\t\t\t\tfirstTRY_2bulge\t\t\t\tfirstTRY_3bulge\n";

foreach my $l (keys %data){
	print $l,"\t";
	if (exists $data{$l}{"canonical"}){print $data{$l}{"canonical"},"\t";}
	else {print "\t\t\t\t";}
	if (exists $data{$l}{"canonicalCbp"}){print $data{$l}{"canonicalCbp"},"\t";}
	else {print "\t\t\t\t";}
	if (exists $data{$l}{"2ntbulge"}){print $data{$l}{"2ntbulge"},"\t";}
	else {print "\t\t\t\t";}
	if (exists $data{$l}{"firstTRY_1bulge"}){print $data{$l}{"firstTRY_1bulge"},"\t";}
	else {print "\t\t\t\t";}
	if (exists $data{$l}{"firstTRY_2bulge"}){print $data{$l}{"firstTRY_2bulge"},"\t";}
	else {print "\t\t\t\t";}
	if (exists $data{$l}{"firstTRY_3bulge"}){print $data{$l}{"firstTRY_3bulge"},"\n";}
	else {print "\t\t\t\t\n";}

}
