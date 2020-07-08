#make_table_5.pl

$bp_dir = $ARGV[0];
open (FH, "$bp_dir/BP_table_4_final.txt") or die $!;

open (FHout, ">$bp_dir/BP_table_5_final.txt") or die $!;

while (<FH>){
	($chrom,$bp,$strand,$motif,$seq,$bpnt,$threess,$bpdist,$pos,$count,$countuniq,$q1,$q2,$c1,$c2,$m1,$m2,$files)=(split /\t/,$_); chomp $files;
	my %fs;
	@f = (split /\,/,$files);
	foreach $a (@f){
		$a =~ /(.+)\(\d+\;(\d+)\;(\d+)\)/;
		$file = $1; $read = $2; $uniq = $3;
		if (exists $fs{$file}){
			$fs{$file}[0] = $fs{$file}[0]+$read;
			$fs{$file}[1] = $fs{$file}[1]+$uniq;
		}
		else {
			$fs{$file}[0] = $read;
			$fs{$file}[1] = $uniq;
		}
	}
	$filestring = "";
	foreach my $key (keys %fs){
		$filestring = $filestring.$key."(".$fs{$key}[0].";".$fs{$key}[1]."),";
	}
	print FHout $chrom,"\t",$bp,"\t",$strand,"\t",$motif,"\t",$seq,"\t",$bpnt,"\t",$threess,"\t",$bpdist,"\t",$pos,"\t",$count,"\t",$countuniq,"\t",$q1,"\t",$q2,"\t",$c1,"\t",$c2,"\t",$m1,"\t",$m2,"\t",$filestring,"\n";
}


