#!/bin/bash

#RUN THIS SCRIPT AFTER map_lariats.sh TO GO FROM LARIAT MAPPING TABLE TO
#FINAL BRANCHPOINT TABLE (OUTPUT TO out_dir/bp_processing/BP_final_table.txt)
#tested with: perl version 5.20.2; bedtools version 2.29.2; python version 3.7.6; python-Levenshtein version 0.12.0

#bowtie indexed genome base name (/path/to/dir/genome where /path/to/dir/genome.fa is the genome fasta)
bowtie_index=$1
genome_fasta=$bowtie_index".fa"
intron_bed=$bowtie_index"_introns.bed"
#output directory; this scripts requires the output of map_lariats.sh (lariat_data_table.txt)
#to be in out_dir/lariat_reads; branchpoint tables are output to out_dir/bp_processing
out_dir=$2
#length of reads that were input to map_lariats.sh
read_len=$3
#number of threads available
threads=$4

read_dir=$out_dir/lariat_reads
bp_dir=$out_dir/bp_processing
if [ -d "$bp_dir" ]; then
	rm -rf $bp_dir
mkdir $bp_dir

echo "$(date +'%m/%d %H:%M:%S') - Making lariat BED files"
perl ./bp_processing_scripts/write_lariat_BED_file.pl $bp_dir $read_dir/lariat_data_table.txt
perl ./bp_processing_scripts/write_BP_5p_TS_BED_files.pl $bp_dir

echo "$(date +'%m/%d %H:%M:%S') - Sorting BED files"
sort -k1,1 -k2,2n $bp_dir/bp_ds_TS_window_coords.bed | uniq > $bp_dir/bp_ds_TS_window_coords_sorted_uniq.bed
sort -k1,1 -k2,2n $bp_dir/bp_window_coords.bed | uniq > $bp_dir/bp_window_coords_sorted_uniq.bed
sort -k1,1 -k2,2n $bp_dir/fivepr_window_coords.bed | uniq > $bp_dir/fivepr_window_coords_sorted_uniq.bed
rm $bp_dir/bp_ds_TS_window_coords.bed $bp_dir/bp_window_coords.bed $bp_dir/fivepr_window_coords.bed

echo "$(date +'%m/%d %H:%M:%S') - Getting genome sequences"
bedtools getfasta -fi $genome_fasta -bed $bp_dir/bp_ds_TS_window_coords_sorted_uniq.bed -fo $bp_dir/bp_ds_TS_window_coords_sorted_uniq_seq.txt -nameOnly -tab -s
bedtools getfasta -fi $genome_fasta -bed $bp_dir/bp_window_coords_sorted_uniq.bed -fo $bp_dir/bp_window_coords_sorted_uniq_seq.txt -nameOnly -tab -s
bedtools getfasta -fi $genome_fasta -bed $bp_dir/fivepr_window_coords_sorted_uniq.bed -fo $bp_dir/fivepr_window_coords_sorted_uniq_seq.txt -nameOnly -tab -s

echo "$(date +'%m/%d %H:%M:%S') - Scoring BP sequences with patser"
perl ./bp_processing_scripts/make_sequences_for_patser.pl $bp_dir/bp_window_coords_sorted_uniq_seq.txt
echo "$bp_dir/bp_window_coords_sorted_uniq_seq_patser.txt" > seq_list.txt
perl ./bp_processing_scripts/run_patser.pl ./patser ./matrix_files/pwm_list.txt ./seq_list.txt $bp_dir
rm seq_list.txt temp_seq.txt
perl ./bp_processing_scripts/parse_patser.pl $bp_dir/bp_window_coords_*_scores.txt > $bp_dir/all_scores.txt
perl ./bp_processing_scripts/take_most_sig_motif.pl $bp_dir/all_scores.txt > $bp_dir/most_sig_bp_motifs.txt

echo "$(date +'%m/%d %H:%M:%S') - Scoring TS sequences with patser"
mkdir $bp_dir/TS; mkdir $bp_dir/TS/fivepr_matrices
perl ./bp_processing_scripts/make_matrices.pl $bp_dir/fivepr_window_coords_sorted_uniq_seq.txt $bp_dir/TS/fivepr_matrices
perl ./bp_processing_scripts/score_ts.pl $bp_dir/bp_ds_TS_window_coords_sorted_uniq_seq.txt ./patser $bp_dir/TS/fivepr_matrices $bp_dir/TS

echo "$(date +'%m/%d %H:%M:%S') - Mapping lariat read mutations"
python ./bp_processing/map_mutation_python.py $read_dir/lariat_data_table.txt $genome_fasta $read_len $threads
#perl ./perl_scripts/map_mutation.pl $read_dir/lariat_data_table.txt $genome_fasta

echo "$(date +'%m/%d %H:%M:%S') - Outputting final BP table"
perl ./bp_processing_scripts/make_read_BED_files.pl $read_dir/lariat_data_table_wReadSeq.txt $read_dir
cut -f5-9 $read_dir/lariat_data_table_wReadSeq.txt | sort | uniq > $read_dir/all_coords_uniq.txt
perl ./bp_processing_scripts/make_circle_BED_file.pl $read_dir/all_coords_uniq.txt > $read_dir/circle.bed
perl ./bp_processing_scripts/make_TS_BED_file.pl $bp_dir/TS/TS_scores_all.txt > $bp_dir/TS/TS.bed
perl ./bp_processing_scripts/make_BP_real_vs_apparent_file.pl $read_dir $bp_dir > $bp_dir/BPs_apparent_real_wFoundFiles_final.txt
perl ./bp_processing_scripts/make_table_1.pl $bp_dir > $bp_dir/BP_table_1_final.txt
perl ./bp_processing_scripts/make_table_2.pl $bp_dir > $bp_dir/BP_table_2_final.txt
perl ./bp_processing_scripts/assign_3ss_and_category.pl $intron_bed $bp_dir/BP_table_2_final.txt > $bp_dir/BP_table_3_final.txt
perl ./bp_processing_scripts/make_table_4.pl $bp_dir/BP_table_3_final.txt $genome_fasta > $bp_dir/BP_table_4_final.txt
perl ./bp_processing_scripts/make_table_5.pl $bp_dir
rm $bp_dir/BP_table_1_final.txt $bp_dir/BP_table_2_final.txt $bp_dir/BP_table_3_final.txt $bp_dir/BP_table_4_final.txt
mv $bp_dir/BP_table_5_final.txt $bp_dir/BP_final_table.txt
