#score_ts.pl

use warnings;

$bp_ts_seq = $ARGV[0];
$patser_path = $ARGV[1];
$matrix_dir = $ARGV[2];
$out_dir = $ARGV[3];

open (FH,$bp_ts_seq) or die $!;
open (FHscores,">$out_dir/TS_scores_all.txt") or die $!;
while (<FH>){
	($id,$seq)=(split /\t/,$_); chomp $seq; $seq =~ tr/[a-z]/[A-Z]/;
	$id =~ /(\w+:\d+_\d+_[\+\-])/;
	$id = $1;
	$matrix = "$matrix_dir/".$id.".txt";
	open (FHout,">temp_seq.txt") or die $!;
	print FHout "seq \\",$seq,"\\";
	close FHout;
	$cmd = "$patser_path -m ".$matrix." -A a 2612 c 2268 t 2577 g 2543 n 0.03 -s -M -1000 < temp_seq.txt";
	$output = `$cmd`;
	 if ($output =~ /score\=\s+(\-?\d+[[:punct:]]?\d*).+value\)\=\s+(\-?\d+\.\d*)\s+sequence\=\s*([ACGTNacgtn]+)/){
        	print FHscores $id,"\t",$1,"\t",$2,"\t",$3,"\n";
    	}
    	else {
        	print "error: $id,\n";
        	print $output,"\n\n\n\n";
    	}
}
