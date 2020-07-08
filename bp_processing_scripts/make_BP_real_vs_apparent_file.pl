#get_mouse_pombe_table1.pl


my %lariats;
my %lariat_file;

my %lariat_file_uniq;

$read_dir = $ARGV[0];
$bp_dir = $ARGV[1];
open (FH, "$read_dir/all_reads.bed") or die $!;
while (<FH>){
	($chrom,$start,$end,$id,$score,$strand)=(split /\t/,$_); chomp $strand;
	$id =~ /.+\/(.+)/;
	$file = $1;
	#if ($_ =~ /(C22[\w\W]*_\d_pair\d_lariat_reads)/){
        #        $file = $1;
        #}
        #elsif ($_ =~ /(HEK[\w\W]+_\d_pair\d_lariat_reads)/){
        #        $file = $1;
        #}
	#else {print "error: $_\n";}
	
	$bp = "";
	if ($strand eq "+"){$bp = $end;}
	if ($strand eq "-"){$bp = $start;}
	$idnew = $chrom.":".$bp."_".$strand; $idnew =~ s/\s//g;
	#print $idnew,"\n";
	if (exists $lariat_file{$idnew}{$file}){$lariat_file{$idnew}{$file}++;}
	else {$lariat_file{$idnew}{$file}=1;}
}
close FH;

open (FH, "$read_dir/uniq_reads.bed") or die $!;


while (<FH>){
	($chrom,$start,$end,$id,$score,$strand)=(split /\t/,$_); chomp $strand;
	$id =~ /.+\/(.+)/;
        $file = $1;
	#if ($_ =~ /(C22[\w\W]*_\d_pair\d_lariat_reads)/){
        #        $file = $1;
        #}
        #elsif ($_ =~ /(HEK[\w\W]+_\d_pair\d_lariat_reads)/){
        #        $file = $1;
        #}
	#else {print "error: $_\n";}

        $bp = "";
        if ($strand eq "+"){$bp = $end;}
        if ($strand eq "-"){$bp = $start;}
        $idnew = $chrom.":".$bp."_".$strand; $idnew =~ s/\s//g;
        #print $idnew,"\n";
        if (exists $lariat_file_uniq{$idnew}{$file}){$lariat_file_uniq{$idnew}{$file}++;}
        else {$lariat_file_uniq{$idnew}{$file}=1;}
}
close FH;



open (FH,"$bp_dir/most_sig_bp_motifs.txt") or die $!;
while (<FH>){
	$line = $_; $line =~ s/^\s+//;
	$id = (split /\t/,$line)[0]; $motif = (split /\t/,$line)[1]; chomp $motif;
	$id =~ s/\s//g;	
	$id =~ /(\w+)\:(\d+)_([+-])/; 
	$chrom = $1; $bp_apparent = $2; $strand = $3;
	$id2 = $chrom.":".$bp_apparent."_".$strand;
	if ($motif eq "none"){
			$lariats{$id2}{"motif"} = "none"; 
			$lariats{$id2}{"bp_real"} = "null"; 
			$lariats{$id2}{"bp_seq"} = "null";
	}
	else {
		$pos = (split /\t/,$line)[2]; $seq = (split /\t/,$_)[3];
		$lariats{$id2}{"motif"} = $motif;
		if (($strand eq "+")&&(($motif eq "canonical")||($motif eq "canonicalC"))){
			$real_bp = ($pos-5)+$bp_apparent;
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "-")&&(($motif eq "canonical")||($motif eq "canonicalC"))){
			$real_bp = $bp_apparent - ($pos-5);
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "+")&&(($motif eq "canonical2nt"))){
			$real_bp = ($pos-4)+$bp_apparent;
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "-")&&(($motif eq "canonical2nt"))){
			$real_bp = $bp_apparent - ($pos-4);
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "+")&&(($motif eq "TRAYTRY"))){
			$real_bp = ($pos-8)+$bp_apparent;
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "-")&&(($motif eq "TRAYTRY"))){
			$real_bp = $bp_apparent - ($pos-8);
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "+")&&(($motif eq "TRANYTRY"))){
			$real_bp = ($pos-7)+$bp_apparent;
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "-")&&(($motif eq "TRANYTRY"))){
			$real_bp = $bp_apparent - ($pos-7);
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "+")&&(($motif eq "TRANNYTRY"))){
			$real_bp = ($pos-6)+$bp_apparent;
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
		elsif (($strand eq "-")&&(($motif eq "TRANNYTRY"))){
			$real_bp = $bp_apparent - ($pos-6);
			$lariats{$id2}{"bp_real"} = $real_bp;
			$lariats{$id2}{"bp_seq"} = $seq;
		}
	}
	
}


open (FH, "$read_dir/circle.bed") or die $!;
while (<FH>){
        ($chrom,$c1,$c2,$circ,$score,$strand)=(split /\t/,$_); chomp $strand;
        $bp = "";
        if ($strand eq "+"){$bp = $c2;}
        elsif ($strand eq "-"){$bp = $c1;}
        $id = $chrom.":".$bp."_".$strand;
        if (exists $lariats{$id}{"motif"}){
                $lariats{$id}{"motif"}="circle";
                $lariats{$id}{"bp_real"} = "null";
                $lariats{$id}{"bp_seq"} = "null";
        }
        else {print "error: $id\n";}
}



open (FH, "$bp_dir/TS/TS.bed") or die $!;
while (<FH>){
	($chrom,$c1,$c2,$TS,$score,$strand)=(split /\t/,$_); chomp $strand;
	$bp = "";
	if ($strand eq "+"){$bp = $c2;}
	elsif ($strand eq "-"){$bp = $c1;}
	$id = $chrom.":".$bp."_".$strand;
	if (exists $lariats{$id}{"motif"}){
		$lariats{$id}{"motif"}="template_switching";
		$lariats{$id}{"bp_real"} = "null"; 
		$lariats{$id}{"bp_seq"} = "null";
	}
	else {print "error: $id\n";}
}




foreach my $key (keys %lariats){
	$found = ""; $total_reads = 0; $uniq_reads = 0; $mismatch_reads = 0; $mismatch_uniq_reads = 0;
	foreach my $key2 (keys %{$lariat_file{$key}}){
		$total_reads = $total_reads + $lariat_file{$key}{$key2};
		if (exists $lariat_file_uniq{$key}{$key2}){$uniq_reads = $uniq_reads+$lariat_file_uniq{$key}{$key2};}
		else {$lariat_file_uniq{$key}{$key2}=0;}
		if (exists $lariat_file_mut{$key}{$key2}){$mismatch_reads = $mismatch_reads+$lariat_file_mut{$key}{$key2};}
		else {$lariat_file_mut{$key}{$key2}=0;}
		if (exists $lariat_file_mut_uniq{$key}{$key2}){$mismatch_uniq_reads = $mismatch_uniq_reads+$lariat_file_mut_uniq{$key}{$key2};}
		else {$lariat_file_mut_uniq{$key}{$key2}=0;}
		$nextkey = $key2."(".$lariat_file{$key}{$key2}.";".$lariat_file_uniq{$key}{$key2}.")";
		$found = $found.$nextkey.",";
	}

	print $key,"\t",$lariats{$key}{"motif"},"\t",$lariats{$key}{"bp_real"},"\t",$lariats{$key}{"bp_seq"},"\t",$found,"\t",$total_reads,"\t",$uniq_reads,"\t",$mismatch_reads,"\t",$mismatch_uniq_reads,"\n";

}
		
