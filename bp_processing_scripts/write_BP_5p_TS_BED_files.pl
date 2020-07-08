#make_bed.pl

$outdir = $ARGV[0];
open (FH, "$outdir/lariats.bed") or die $!;
open (FH1,">$outdir/bp_window_coords.bed") or die $!;
open (FH2,">$outdir/fivepr_window_coords.bed") or die $!;
open (FH3,">$outdir/bp_ds_TS_window_coords.bed") or die $!;

while (<FH>){
	($chrom,$coord1,$coord2,$id,$score,$strand)=(split /\t/,$_); chomp $strand;
	$bp_c1 = 0; $bp_c2 = 0; $fivepr = 0; $fivepr_2 = 0;$bp = 0;$ts_1 = 0; $ts_2 = 0;$fivepr_actual = 0;
	if ($strand eq "+"){
		$bp_c1 = $coord2-10; $bp_c2 = $coord2+10;
		$fivepr = $coord1; $fivepr_2 = $coord1+6;
		$bp = $coord2;
		$ts_1=$bp; $ts_2 = $bp+6;
		$fivepr_actual = $coord1;
	}
	if ($strand eq "-"){
		$bp_c1 = $coord1-10; $bp_c2 = $coord1+10;
		$fivepr = $coord2-6; $fivepr_2 = $coord2;
		$bp = $coord1;
		$ts_1 = $bp-6; $ts_2 = $bp;
		$fivepr_actual = $coord2;
	}
	print FH1 $chrom,"\t",$bp_c1,"\t",$bp_c2,"\t",$chrom.":",$bp,"_",$strand,"\t0\t",$strand,"\n";
	print FH2 $chrom,"\t",$fivepr,"\t",$fivepr_2,"\t",$chrom,":",$fivepr_actual,"_",$bp."_",$strand,"\t0\t",$strand,"\n";
	print FH3 $chrom,"\t",$ts_1,"\t",$ts_2,"\t",$chrom,":",$fivepr_actual,"_",$bp,"_",$strand,"\t0\t",$strand,"\n";
}

