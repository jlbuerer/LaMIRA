#make_sequences.pl
#Output branchpoint sequences for motif scoring by patser
use warnings;

open (FH, $ARGV[0]) or die $!;
$ARGV[0] =~ /(.+).txt/;
$fhout = $1."_patser.txt";
open (FHout, ">$fhout") or die $!;


while (<FH>){
	($id,$seq)=(split /\t/,$_);
	chomp $seq;
	$seq =~ tr/[a-z]/[A-Z]/;
	print FHout $id,"\t\\",$seq,"\\\n";
}

close FH;
