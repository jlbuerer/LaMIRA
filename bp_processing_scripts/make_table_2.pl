#parse_table.pl

use warnings;

$bp_dir = $ARGV[0];
open (FH, "$bp_dir/BP_table_1_final.txt") or die $!;
while (<FH>){
	unless ($_ =~ /branchpoint/){
	$line = $_;	
	($chrom,$bp,$strand,$motif,$seq,$pos1,$pos2,$pos3,$pos4,$source)=(split /\t/,$_);
	chomp $source;
	$pos1new = "";
	$pos2new = "";
	$pos3new = "";
	$pos4new = "";
	
	if (($motif eq "canonical")||($motif eq "canonicalC")||($motif eq "TRAYTRY")){
		if ($pos1 =~ /0\,0\,0\,(\d+)\,(\d+)\,(\d+)/){
			$pos1new = $1.",".$2."(".$3.")";
		}
		else {print "error: $line";}
	}
	elsif (($motif eq "canonical2nt")||($motif eq "TRANYTRY")){
		if ($pos1 =~ /0\,0\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
			$pos1new = $1.",".$2."(".$3.",".$4.")";
		}
		else {print "error: $line";}
	}
	elsif (($motif eq "TRANNYTRY")){
		if ($pos1 =~ /0\,(\d+)\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
			$pos1new = $1.",".$2."(".$3.",".$4.",".$5.")";
		}
		else {print "error: $line";}
	}
	elsif ($motif eq "none"){
		if ($pos1 =~ /0\,0\,0\,0\,0\,(\d+)/){
			$pos1new = $1;
		}
		else {print "error: $line";}
	}
	elsif ($motif eq "template_switching"){
                if ($pos1 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos1new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "circle"){
                if ($pos1 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos1new = $1;
                }
                else {print "error: $line";}
        }



        if (($motif eq "canonical")||($motif eq "canonicalC")||($motif eq "TRAYTRY")){
                if ($pos2 =~ /0\,0\,0\,(\d+)\,(\d+)\,(\d+)/){
                        $pos2new = $1.",".$2."(".$3.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "canonical2nt")||($motif eq "TRANYTRY")){
                if ($pos2 =~ /0\,0\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos2new = $1.",".$2."(".$3.",".$4.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "TRANNYTRY")){
                if ($pos2 =~ /0\,(\d+)\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos2new = $1.",".$2."(".$3.",".$4.",".$5.")";
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "none"){
                if ($pos2 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos2new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "template_switching"){
                if ($pos2 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos2new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "circle"){
                if ($pos2 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos2new = $1;
                }
                else {print "error: $line";}
        }






        if (($motif eq "canonical")||($motif eq "canonicalC")||($motif eq "TRAYTRY")){
                if ($pos3 =~ /0\,0\,0\,(\d+)\,(\d+)\,(\d+)/){
                        $pos3new = $1.",".$2."(".$3.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "canonical2nt")||($motif eq "TRANYTRY")){
                if ($pos3 =~ /0\,0\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos3new = $1.",".$2."(".$3.",".$4.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "TRANNYTRY")){
                if ($pos3 =~ /0\,(\d+)\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos3new = $1.",".$2."(".$3.",".$4.",".$5.")";
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "none"){
                if ($pos3 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos3new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "template_switching"){
                if ($pos3 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos3new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "circle"){
                if ($pos3 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos3new = $1;
                }
                else {print "error: $line";}
        }





        if (($motif eq "canonical")||($motif eq "canonicalC")||($motif eq "TRAYTRY")){
                if ($pos4 =~ /0\,0\,0\,(\d+)\,(\d+)\,(\d+)/){
                        $pos4new = $1.",".$2."(".$3.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "canonical2nt")||($motif eq "TRANYTRY")){
                if ($pos4 =~ /0\,0\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos4new = $1.",".$2."(".$3.",".$4.")";
                }
                else {print "error: $line";}
        }
        elsif (($motif eq "TRANNYTRY")){
                if ($pos4 =~ /0\,(\d+)\,(\d+)\,(\d+)\,(\d+)\,(\d+)/){
                        $pos4new = $1.",".$2."(".$3.",".$4.",".$5.")";
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "none"){
                if ($pos4 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos4new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "template_switching"){
                if ($pos4 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos4new = $1;
                }
                else {print "error: $line";}
        }
        elsif ($motif eq "circle"){
                if ($pos4 =~ /0\,0\,0\,0\,0\,(\d+)/){
                        $pos4new = $1;
                }
                else {print "error: $line";}
        }









	print $chrom,"\t",$bp,"\t",$strand,"\t",$motif,"\t",$seq,"\t",$pos1new,"\t",$pos2new,"\t",$pos3new,"\t",$pos4new,"\t",$source,"\n";
	}
	
	else {print $_;}
}
