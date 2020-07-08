#write_bed.pl
#Takes a list of lariat tables output by find_lariats and outputs the lariats in BED format
$outdir = $ARGV[0];
$numargs = $#ARGV;
open (FHout, ">$outdir/lariats.bed") or die $!;
for (my $j = 1; $j<=$numargs;$j++){

	$file = $ARGV[$j];
	$file =~ /(x\d+)/;
	open (FH, $file) or die $!;
	
	while (<FH>){
		$sample = (split /\t/,$_)[0];
		$chrom = (split /\t/,$_)[4];	
		$strand = (split /\t/,$_)[5];
		$fivepr = (split /\t/,$_)[6];
		$bp = (split /\t/,$_)[8];
		if ($strand eq "+"){
			print FHout $chrom,"\t",$fivepr,"\t",$bp,"\t",$sample,"\t0\t",$strand,"\n";
		}
		elsif ($strand eq "-"){
			print FHout $chrom,"\t",$bp,"\t",$fivepr,"\t",$sample,"\t0\t",$strand,"\n";
		}
	}
	close FH; 
}

