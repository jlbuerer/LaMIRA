#make_bed_files.pl

#goal: 
###bed file for all reads
###bed file for uniq reads
###bed file for mismatch at BP all reads
###bed file for mismatch at BP uniq reads

use warnings;

my %read;
my %read_BPmismatch;

$out_dir = $ARGV[1];
open (FHallreads,">$out_dir/all_reads.bed") or die $!;

open (FH, $ARGV[0]) or die $!;
while (<FH>){
	$info = (split /\t/,$_)[0];
	$read = (split /\t/,$_)[3];
	$chrom = (split /\t/,$_)[4];
	$strand = (split /\t/,$_)[5];
	$fivepr = (split /\t/,$_)[6];
	$bp = (split /\t/,$_)[8];
	
	$bedline = "";
	if ($strand eq "+"){
		$bedline = $chrom."\t".$fivepr."\t".$bp."\t".$info."\t0\t+\n";
	}
	elsif ($strand eq "-"){
		$bedline = $chrom."\t".$bp."\t".$fivepr."\t".$info."\t0\t-\n";
	}
	print FHallreads $bedline;

	$id = $info."\t".$read;
	$read{$id}=$bedline;

}
close FH;


open (FHuniqreads,">$out_dir/uniq_reads.bed") or die $!;


foreach my $r (keys %read){
	print FHuniqreads $read{$r};
}













