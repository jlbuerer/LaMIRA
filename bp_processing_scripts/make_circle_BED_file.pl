#make_circle_bed.pl

use warnings;
#read in uniq coords, chrom strand fivepr threepr bp
open (FH, $ARGV[0]) or die $!;

my %circle;

while (<FH>){
	($chrom,$strand,$fivepr,$threepr,$bp)=(split /\t/,$_); chomp $bp;
	if ($threepr =~ /\d/){
	if ($threepr ==$bp){
		if ($strand eq "+"){
			print $chrom,"\t",$fivepr,"\t",$threepr,"\tcircle\t0\t+\n";
		}
		elsif ($strand eq "-"){
			print $chrom,"\t",$threepr,"\t",$fivepr,"\tcircle\t0\t-\n";
		}
	}}
}
close FH;
