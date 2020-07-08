#take_most_sig_motif.pl

use warnings;

$score_file = $ARGV[0];
open (FH, $score_file) or die $!;

while (<FH>){
	if ($_ =~ /chr\w+/){
		$loci = (split /\t/,$_)[0];

		$canonical_startpos = (split /\t/,$_)[1];
		$canonical_seq = (split /\t/,$_)[2];
		$canonical_lnp = (split /\t/,$_)[4];
		unless ($canonical_lnp =~ /\d/){$canonical_lnp = 10;}

		$canonicalC_startpos = (split /\t/,$_)[5];
		$canonicalC_seq = (split /\t/,$_)[6];
		$canonicalC_lnp = (split /\t/,$_)[8];
		unless ($canonicalC_lnp =~ /\d/){$canonicalC_lnp = 10;}

		$canonical2nt_startpos = (split /\t/,$_)[9];
		$canonical2nt_seq = (split /\t/,$_)[10];
		$canonical2nt_lnp = (split /\t/,$_)[12];
		unless ($canonical2nt_lnp =~ /\d/){$canonical2nt_lnp = 10;}

		$TRAYTRY_startpos = (split /\t/,$_)[13];
		$TRAYTRY_seq = (split /\t/,$_)[14];
		$TRAYTRY_lnp = (split /\t/,$_)[16];
		unless ($TRAYTRY_lnp =~ /\d/){$TRAYTRY_lnp = 10;}

		$TRANYTRY_startpos = (split /\t/,$_)[17];
		$TRANYTRY_seq = (split /\t/,$_)[18];
		$TRANYTRY_lnp = (split /\t/,$_)[20];
		unless ($TRANYTRY_lnp =~ /\d/){$TRANYTRY_lnp = 10;}

		$TRANNYTRY_startpos = (split /\t/,$_)[21];
		$TRANNYTRY_seq = (split /\t/,$_)[22];
		$TRANNYTRY_lnp = (split /\t/,$_)[24]; chomp $TRANNYTRY_lnp;
		unless ($TRANNYTRY_lnp =~ /\d/){$TRANNYTRY_lnp = 10;}
	
		$min_lnp = -3.912; #p-val < .02
		
		print $loci;
		if (($canonical_lnp < $min_lnp)||($canonicalC_lnp < $min_lnp)||($canonical2nt_lnp < $min_lnp)||($TRAYTRY_lnp < $min_lnp)||($TRANYTRY_lnp < $min_lnp)||($TRANNYTRY_lnp < $min_lnp)){
			my $flag = 0;			
			if (($canonical_lnp <= $canonicalC_lnp)&&($canonical_lnp <= $canonical2nt_lnp)&&($canonical_lnp <= $TRAYTRY_lnp)&&($canonical_lnp <= $TRANYTRY_lnp)&&($canonical_lnp <= $TRANNYTRY_lnp)){
				print "\tcanonical\t",$canonical_startpos,"\t",$canonical_seq,"\t",$canonical_lnp,"\n"; $flag = 1;
			}
			elsif (($canonicalC_lnp <= $canonical_lnp)&&($canonicalC_lnp <= $canonical2nt_lnp)&&($canonicalC_lnp <= $TRAYTRY_lnp)&&($canonicalC_lnp <= $TRANYTRY_lnp)&&($canonicalC_lnp <= $TRANNYTRY_lnp)){
				print "\tcanonicalC\t",$canonicalC_startpos,"\t",$canonicalC_seq,"\t",$canonicalC_lnp,"\n"; $flag = 1;
			}

			elsif (($canonical2nt_lnp <= $canonicalC_lnp)&&($canonical2nt_lnp <= $canonical_lnp)&&($canonical2nt_lnp <= $TRAYTRY_lnp)&&($canonical2nt_lnp <= $TRANYTRY_lnp)&&($canonical2nt_lnp <= $TRANNYTRY_lnp)){
				print "\tcanonical2nt\t",$canonical2nt_startpos,"\t",$canonical2nt_seq,"\t",$canonical2nt_lnp,"\n"; $flag = 1;
			}

			elsif (($TRAYTRY_lnp <= $canonicalC_lnp)&&($TRAYTRY_lnp <= $canonical2nt_lnp)&&($TRAYTRY_lnp <= $canonical_lnp)&&($TRAYTRY_lnp <= $TRANYTRY_lnp)&&($TRAYTRY_lnp <= $TRANNYTRY_lnp)){
				print "\tTRAYTRY\t",$TRAYTRY_startpos,"\t",$TRAYTRY_seq,"\t",$TRAYTRY_lnp,"\n"; $flag = 1;
			}

			elsif (($TRANYTRY_lnp <= $canonicalC_lnp)&&($TRANYTRY_lnp <= $canonical2nt_lnp)&&($TRANYTRY_lnp <= $TRAYTRY_lnp)&&($TRANYTRY_lnp <= $canonical_lnp)&&($TRANYTRY_lnp <= $TRANNYTRY_lnp)){
				print "\tTRANYTRY\t",$TRANYTRY_startpos,"\t",$TRANYTRY_seq,"\t",$TRANYTRY_lnp,"\n"; $flag = 1;
			}

			elsif (($TRANNYTRY_lnp <= $canonicalC_lnp)&&($TRANNYTRY_lnp <= $canonical2nt_lnp)&&($TRANNYTRY_lnp <= $TRAYTRY_lnp)&&($TRANNYTRY_lnp <= $TRANYTRY_lnp)&&($TRANNYTRY_lnp <= $canonical_lnp)){
				print "\tTRANNYTRY\t",$TRANNYTRY_startpos,"\t",$TRANNYTRY_seq,"\t",$TRANNYTRY_lnp,"\n"; $flag = 1;
			}
			else {print "error: $loci \n";}
			if ($flag==0){print "\tnone\n";}
		}
		else {print "\tnone\n";}
	
	}
}



