#assign_3ss_and_category.pl

use warnings;

my %ss;
$intron_file = $ARGV[0];
open (FH, $intron_file) or die $!;
while (<FH>){
    $chrom = (split /\t/,$_)[0];
    $coord1 = (split /\t/,$_)[1];
    $coord2 = (split /\t/,$_)[2];
    $strand = (split /\t/,$_)[5]; chomp $strand;
    if ($strand eq "+"){
        $threess = $chrom."_".$strand."_".$coord2;
        $ss{$threess}=1;
    }
    if ($strand eq "-"){
        $threess = $chrom."_".$strand."_".$coord1;
        $ss{$threess}=1;
    }
} close FH;
$bp_table = $ARGV[1];
open (FH, $bp_table) or die $!;
while (<FH>){
    
	($chrom,$bp,$strand,$motif,$seq,$pos1,$pos2,$pos3,$pos4,$source)=(split /\t/,$_);chomp $source;
	$flag = 0;
	my $j= 0;
	$category = "";
	$true3ss = "";
	$dist = "";
    	while ($flag==0){
    	$threess = "";
    	if ($strand eq "+"){
        $threess = $chrom."_".$strand."_".($bp+$j);
        }
        elsif ($strand eq "-"){
        $threess = $chrom."_".$strand."_".($bp-$j);
        }
        
        if (exists $ss{$threess}){
            
            if ($strand eq "+"){
					$threess = $bp+$j;
                    $flag = 1;
                    $true3ss = $threess;

            }
            if ($strand eq "-"){
					$threess = $bp-$j;
                    $flag = 1;
                    $true3ss = $threess;

            }
        }
        $j++;
        if ($j > 1000000){$flag = 2;}
    }
if ($flag ==2){$dist = "null"; $true3ss = "null"; $category = "null";}
else {
    if ($strand eq "+"){
        $dist = $bp - $true3ss;
    }
    elsif ($strand eq "-"){
        $dist = $true3ss - $bp;
    }
    if ($dist > 0){
        $category = "inside 3ss";
    }
    elsif ($dist ==0){
    	$category = "circle";
    }
    elsif ($dist >=-10){
        $category = "proximal";
    }
    elsif ($dist >= -60){
        $category = "expected";
    }
    else {
        $category = "distal";
    }}
    
	print $chrom,"\t",$bp,"\t",$strand,"\t",$motif,"\t",$seq,"\t",$pos1,"\t",$pos2,"\t",$pos3,"\t",$pos4,"\t",$true3ss,"\t",$dist,"\t",$category,"\t",$source,"\n";
    
}

                
        
        
        
        
