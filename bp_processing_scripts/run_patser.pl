
use warnings;

$patser_path = $ARGV[0];
$pwm_list = $ARGV[1];
$seq_list = $ARGV[2];
$out_dir = $ARGV[3];
open (FH, $pwm_list) or die $!;
while (<FH>){
	$pwm = $_; chomp $pwm;
	open (FH2, $seq_list) or die $!;
	while (<FH2>){
		$seq = $_; chomp $seq;
		$seq =~ /.+\/(.+)_patser\.txt/;
		$id1 = $1;
		$pwm =~ /files\/(.+)_pwm/;
		$id2 = $1;
		$outfile = "$out_dir/".$id1."_".$id2."_scores.txt";
		$cmd = "$patser_path -m ".$pwm." -f ".$seq." -A a:t 1 c:g 1 -s -t -M -100  > ".$outfile;
		#print $cmd,"\n";
		system($cmd);
	}
	close FH2;
}

