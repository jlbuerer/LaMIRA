#make_TS_bed.pl

$score_file = $ARGV[0];
open (FH, $score_file) or die $!;

while (<FH>){
	($event,$score,$lnp,$seq)=(split /\t/,$_);
	chomp $seq;
	$event =~ /(chr\w+)\:(\d+)_(\d+)_([+-])/;
	$chrom = $1; $fivepr = $2; $threepr = $3; $strand = $4;
	$min_lnp = -3.912; #pval<.02
	if ($lnp<=$min_lnp){
		if ($strand eq "+"){
			print $chrom,"\t",$fivepr,"\t",$threepr,"\tTS\t0\t+\n";
		}
		elsif ($strand eq "-"){
			print $chrom,"\t",$threepr,"\t",$fivepr,"\tTS\t0\t-\n";
		}
	}
}
close FH;
