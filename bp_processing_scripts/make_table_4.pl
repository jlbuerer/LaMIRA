#make_table_4.pl

use warnings;

$bp_table = $ARGV[0];
$genome_fasta = $ARGV[1];
open (FH, $bp_table) or die $!;

while (<FH>){
	($chrom,$bp,$strand,$motif,$seq,$readtot,$readuniq,$misread,$misuniq,$threeprss,$bpdist,$category,$sources)=(split /\t/,$_);
	$line = $_;
	chomp $sources;
	$seq2 = "";$bpnt = "";
	if ($line =~ /circle/){
		$motif = "circle";
		$c1 = $bp - 5; $c2 = $bp+5;
		open (FHout, ">temp.bed") or die $!;
		print FHout $chrom,"\t",$c1,"\t",$c2,"\tbed\t0\t",$strand,"\n";
		close FHout;		
		$cmd = "bedtools getfasta -fi $genome_fasta -bed temp.bed -s -tab -fo temp.fa";
		system($cmd);
		open (FH2,"temp.fa") or die $!;
		$seqcirc = "";
		while (<FH2>){
			($id,$seqcirc)=(split /\t/,$_); chomp $seqcirc;
		}
		close FH2;
		$seqcirc =~ tr/[a-z]/[A-Z]/;
		$seqcirc =~ /^(....)(.)(.....)/;
		$seq2 = $1.$2."*".$3;
		$bpnt = $2;
	}
			
	elsif ($motif eq "none"){
		$c1 = $bp - 5; $c2 = $bp+5;
		open (FHout, ">temp.bed") or die $!;
		print FHout $chrom,"\t",$c1,"\t",$c2,"\tbed\t0\t",$strand,"\n";
		close FHout;		
		$cmd = "bedtools getfasta -fi $genome_fasta -bed temp.bed -s -tab -fo temp.fa";
		system($cmd);
		open (FH2,"temp.fa") or die $!;
		$seqcirc = "";
		while (<FH2>){
			($id,$seqcirc)=(split /\t/,$_); chomp $seqcirc;
		}
		close FH2;
		$seqcirc =~ tr/[a-z]/[A-Z]/;
		$seqcirc =~ /^(....)(.)(.....)/;
		$seq2 = $1.$2."*".$3;
		$bpnt = $2;
	}	
	elsif ($motif eq "template_switching"){
		$c1 = $bp - 5; $c2 = $bp+5;
		open (FHout, ">temp.bed") or die $!;
		print FHout $chrom,"\t",$c1,"\t",$c2,"\tbed\t0\t",$strand,"\n";
		close FHout;		
		$cmd = "bedtools getfasta -fi $genome_fasta -bed temp.bed -s -tab -fo temp.fa";
		system($cmd);
		open (FH2,"temp.fa") or die $!;
		$seqcirc = "";
		while (<FH2>){
			($id,$seqcirc)=(split /\t/,$_); chomp $seqcirc;
		}
		close FH2;
		$seqcirc =~ tr/[a-z]/[A-Z]/;
		$seqcirc =~ /^(....)(.)(.....)/;
		$seq2 = $1.$2."*".$3;
		$bpnt = $2;
	}	
	elsif ($motif eq "canonical"){
		if ($seq =~ /^(.....)(.)(.)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnt = $bulge;
			$seq2 = $us."(".$bulge."*)".$ds;
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}
	elsif ($motif eq "canonicalC"){		
		if ($seq =~ /^(.....)(.)(.)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnt = $bulge;
			$seq2 = $us."(".$bulge."*)".$ds;
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}
	elsif ($motif eq "canonical2nt"){		
		if ($seq =~ /^(.....)(..)(.)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnts = $bulge;
			if ($readuniq =~ /(\d+)\,(\d+)\((\d+)\,(\d+)\)/){
				$min2 = $1; $min1 = $2; $b1 = $3; $b2 = $4;
				$pos1score = $min2+$min1+$b1;
				$pos2score = $min1+$b1+$b2;
				if ($pos2score == $pos1score){
					if ($b1>$b2){
						$bulge =~ /(.)(.)/;
						$b1nt = $1; $b2nt = $2;
						$seq2 = $us."(".$b1nt."*".$b2nt.")".$ds;
						$bpnt = $b1nt;
						if ($strand eq "+"){ 
							$bp = $bp-1; $bpdist = $bpdist+1;
						}
						elsif ($strand eq "-"){
							$bp = $bp+1; $bpdist = $bpdist+1;
						}
					}
					else {
						$bulge =~ /(.)(.)/;
						$b1nt = $1; $b2nt = $2;
						$seq2 = $us."(".$b1nt.$b2nt."*)".$ds;
						$bpnt = $b2nt;
					}
				}
				elsif ($pos2score>$pos1score){

					$bulge =~ /(.)(.)/;
					$b1nt = $1; $b2nt = $2;
					$seq2 = $us."(".$b1nt.$b2nt."*)".$ds;
					$bpnt = $b2nt;
				}
				else {
					$bulge =~ /(.)(.)/;
					$b1nt = $1; $b2nt = $2;
					$seq2 = $us."(".$b1nt."*".$b2nt.")".$ds;
					$bpnt = $b1nt;
					if ($strand eq "+"){ 
						$bp = $bp-1; $bpdist = $bpdist+1;
					}
					elsif ($strand eq "-"){
						$bp = $bp+1; $bpdist = $bpdist+1;
					}
		
				}
			}
			else {print "error: $line";}
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}
	elsif ($motif eq "TRAYTRY"){
		if ($seq =~ /^(..)(.)(....)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnt = $bulge;
			$seq2 = $us."(".$bulge."*)".$ds;
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}
	elsif ($motif eq "TRANYTRY"){
		if ($seq =~ /^(..)(..)(....)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnts = $bulge;
			if ($readuniq =~ /(\d+)\,(\d+)\((\d+)\,(\d+)\)/){
				$min2 = $1; $min1 = $2; $b1 = $3; $b2 = $4;
				$pos1score = $min2+$min1+$b1;
				$pos2score = $min1+$b1+$b2;
				if ($pos2score == $pos1score){
					if ($b1>$b2){
						$bulge =~ /(.)(.)/;
						$b1nt = $1; $b2nt = $2;
						$seq2 = $us."(".$b1nt."*".$b2nt.")".$ds;
						$bpnt = $b1nt;
						if ($strand eq "+"){ 
							$bp = $bp-1; $bpdist = $bpdist+1;
						}
						elsif ($strand eq "-"){
							$bp = $bp+1; $bpdist = $bpdist+1;
						}
					}
					else {
						$bulge =~ /(.)(.)/;
						$b1nt = $1; $b2nt = $2;
						$seq2 = $us."(".$b1nt.$b2nt."*)".$ds;
						$bpnt = $b2nt;
					}
				}
				elsif ($pos2score>$pos1score){

					$bulge =~ /(.)(.)/;
					$b1nt = $1; $b2nt = $2;
					$seq2 = $us."(".$b1nt.$b2nt."*)".$ds;
					$bpnt = $b2nt;
				}
				else {
					$bulge =~ /(.)(.)/;
					$b1nt = $1; $b2nt = $2;
					$seq2 = $us."(".$b1nt."*".$b2nt.")".$ds;
					$bpnt = $b1nt;
					if ($strand eq "+"){ 
						$bp = $bp-1; $bpdist = $bpdist+1;
					}
					elsif ($strand eq "-"){
						$bp = $bp+1; $bpdist = $bpdist+1;
					}
		
				}
			}
			else {print "error: $line";}
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}
	elsif ($motif eq "TRANNYTRY"){
		if ($seq =~ /^(..)(...)(....)$/){
			$us = $1; $bulge = $2; $ds = $3;
			$bpnts = $bulge;
			if ($readuniq =~ /(\d+)\,(\d+)\((\d+)\,(\d+)\,(\d+)\)/){
				$min2 = $1; $min1 = $2; $b1 = $3; $b2 = $4; $b3 = $5;
				$pos1score = $min2+$min1+$b1;
				$pos2score = $min1+$b1+$b2;
				$pos3score = $b1+$b2+$b3;
				#allscoresequal
				if (($pos1score==$pos2score)&&($pos2score==$pos3score)){

					if (($b1 ==$b2)&&($b2==$b3)){
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
						$bpnt = $b3nt;
					}
					elsif (($b1>$b2)&&($b1>$b3)){
						if ($strand eq "+"){
							$bp = $bp-2;
							$bpdist = $bpdist+2;
						}
						elsif ($strand eq "-"){
							$bp = $bp+2;
							$bpdist = $bpdist+2;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt."*".$b2nt.$b3nt.")".$ds;
						$bpnt = $b1nt;
					}
					elsif (($b2 > $b3)&&($b2>$b1)){
						if ($strand eq "+"){
							$bp = $bp-1;
							$bpdist = $bpdist+1;
						}
						elsif ($strand eq "-"){
							$bp = $bp+1;
							$bpdist = $bpdist+1;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt."*".$b3nt.")".$ds;
						$bpnt = $b2nt;
					}
					elsif (($b3>$b2)&&($b3>$b1)){
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
						$bpnt = $b3nt;
					}
					elsif (($b1==$b2)&&($b1>$b3)){
						if ($strand eq "+"){
							$bp = $bp-1;
							$bpdist = $bpdist+1;
						}
						elsif ($strand eq "-"){
							$bp = $bp+1;
							$bpdist = $bpdist+1;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt."*".$b3nt.")".$ds;
						$bpnt = $b2nt;
					}
					else {
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
						$bpnt = $b3nt;
					}
				}
				#pos3&2 > pos1, but are equal
				elsif (($pos3score>$pos1score)&&($pos3score==$pos2score)){
					if ($b2>$b3){
						if ($strand eq "+"){
							$bp = $bp-1;
							$bpdist = $bpdist+1;
						}
						elsif ($strand eq "-"){
							$bp = $bp+1;
							$bpdist = $bpdist+1;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt."*".$b3nt.")".$ds;
						$bpnt = $b2nt;
					}
					else {
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
						$bpnt = $b3nt;
					}
				}
				elsif (($pos3score ==$pos1score)&&($pos1score>$pos2score)){
					if ($b1>$b3){
						if ($strand eq "+"){
							$bp = $bp-2;
							$bpdist = $bpdist+2;
						}
						elsif ($strand eq "-"){
							$bp = $bp+2;
							$bpdist = $bpdist+2;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt."*".$b2nt.$b3nt.")".$ds;
						$bpnt = $b1nt;
					}
					else {
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
						$bpnt = $b3nt;
					}
				}
				#pos1 >2/3
				elsif (($pos1score>$pos2score)&&($pos1score>$pos3score)){
					if ($strand eq "+"){
						$bp = $bp-2; $bpdist = $bpdist+2;
					}
					elsif ($strand eq "-"){
						$bp = $bp+2; $bpdist = $bpdist+2;
					}
					$bulge =~ /(.)(.)(.)/;
					$b1nt = $1; $b2nt = $2;$b3nt = $3;
					$seq2 = $us."(".$b1nt."*".$b2nt.$b3nt.")".$ds;
					$bpnt = $b1nt;
				}
				#pos2 > 1/3
				elsif (($pos2score>$pos1score)&&($pos2score>$pos3score)){
					if ($strand eq "+"){
						$bp = $bp-1; $bpdist = $bpdist+1;
					}
					elsif ($strand eq "-"){
						$bp = $bp+1; $bpdist = $bpdist+1;
					}
					$bulge =~ /(.)(.)(.)/;
					$b1nt = $1; $b2nt = $2;$b3nt = $3;
					$seq2 = $us."(".$b1nt.$b2nt."*".$b3nt.")".$ds;
					$bpnt = $b2nt;
				}
				#pos3 > 1/2			
				elsif (($pos3score>$pos1score)&&($pos3score>$pos2score)){
					$bulge =~ /(.)(.)(.)/;
					$b1nt = $1; $b2nt = $2;$b3nt = $3;
					$seq2 = $us."(".$b1nt.$b2nt.$b3nt."*)".$ds;
					$bpnt = $b3nt;
				}
				#pos1=2, > 3
				elsif (($pos1score==$pos2score)&&($pos1score>$pos3score)){

					if ($b1>$b3){
						if ($strand eq "+"){
							$bp = $bp-2;
							$bpdist = $bpdist+2;
						}
						elsif ($strand eq "-"){
							$bp = $bp+2;
							$bpdist = $bpdist+2;
						}
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt."*".$b2nt.$b3nt.")".$ds;
						$bpnt = $b1nt;
					}
					else {
						$bulge =~ /(.)(.)(.)/;
						$b1nt = $1; $b2nt = $2;$b3nt = $3;
						$seq2 = $us."(".$b1nt.$b2nt."*".$b3nt.")".$ds;
						$bpnt = $b2nt;
					}
				}
				else {print "logic bpfind error: $line";}
				
			}
			else {print "error: $line";}
		}
		else {print "error: $line";}
		$readtot =~ s/\(/\,\(/;
		$readuniq =~ s/\(/\,\(/;
		$misread =~ s/\(/\,\(/;
		$misuniq =~ s/\(/\,\(/;
	}

	$mutation = "no";
	$multiple = "no";
	$totalreadevidence = 0; $totaluniqreadevidence = 0;
	$t = $readtot; $u = $readuniq; $m = $misread;
	$t =~ s/[[:punct:]]/\t/g;
	$u =~ s/[[:punct:]]/\t/g;
	$m =~ s/[[:punct:]]/\t/g;
	@tl = (split /\t/,$t); @ul = (split /\t/,$u); @ml = (split /\t/,$m);
	foreach (@tl){
		if ($_ =~ /(\d+)/){
		$totalreadevidence = $totalreadevidence+$1;
		}
	}
	foreach (@ul){
		if ($_ =~ /(\d+)/){
		$totaluniqreadevidence = $totaluniqreadevidence+$1;
		}
	}
	foreach (@ml){
		if ($_ =~ /(\d+)/){
		if ($_ >0){$mutation = "yes";}
		}
	}
	@sourcelist = (split /\,/,$sources);
	$num = 0;
	foreach (@sourcelist){
		if ($_ =~ /\w+/){
			$num++;
		}
	}
	if ($num > 1){$multiple = "yes";}


	print $chrom,"\t",$bp,"\t",$strand,"\t",$motif,"\t",$seq2,"\t",$bpnt,"\t",$threeprss,"\t",$bpdist,"\t",$category,"\t",$totalreadevidence,"\t",$totaluniqreadevidence,"\t",$mutation,"\t",$multiple,"\t",$readtot,"\t",$readuniq,"\t",$misread,"\t",$misuniq,"\t",$sources,"\n";
}

	

