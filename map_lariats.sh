#!/bin/bash

#RUN THIS SCRIPT TO MAP LARIAT READS AND OUTPUT lariat_data_table.txt
#tested with: perl version 5.20.2; bowtie version 1.1.1; bedtools version 2.29.2

#single read file (paired-end read files should be processed separately)
read_file=$1 
#all reads should be trimmed to a uniform length
read_len=$2 
#bowtie indexed genome base name (ex. /path/to/dir/genome where /path/to/dir/genome.fa is the genome fasta)
bowtie_index=$3
#GTF annotation file containing the exon information for mapping genome
gtf_file=$4
#number of threads available
threads=$5
#output directory (this script outputs lariat mapping data to out_dir/lariat_reads)
out_dir=$6

read_dir=$out_dir/lariat_reads

if [[ ! -d $out_dir ]]; then
	mkdir $out_dir
fi
if [[ ! -d $read_dir ]]; then
	mkdir $read_dir
fi

read_file_dir=$(dirname -- "$read_file")
read_file_base=$(basename -- "$read_file")
extension="${read_file_base##*.}"

if [[ $extension == "gz" ]]; then
	gunzip -c $read_file > $read_dir/seq.fastq
else
	cp $read_file $read_dir/seq.fastq
fi

if [[ ! -f $bowtie_index"_ss_table.txt" || ! -f $bowtie_index"_introns.bed" ]]; then
    python ./mapping_scripts/create_SS_and_intron_tables.py $gtf_file $bowtie_index
fi

perl ./mapping_scripts/find_lariats.pl -l $read_len -f $read_file -i $bowtie_index -t $threads -o $read_dir
