import sys
import numpy as np
from os.path import join
from subprocess import run
import threading
import time
from Levenshtein import distance

nt_comp = {'A':'T', 'T':'A', 'C':'G', 'G':'C', 'N':'N'}
lariats_done = 0

class mut_thread (threading.Thread):
	def __init__(self, lariats, genomic_seqs, read_len):
		threading.Thread.__init__(self)
		self.lariats = lariats
		self.genomic_seqs = genomic_seqs
		self.read_len = read_len
	def run(self):
		self.out_lines = find_genomic_BP_seq(self.lariats, self.genomic_seqs, self.read_len)

def reverse_complement(seq):
	return ''.join([nt_comp[seq[i]] for i in range(len(seq)-1,-1,-1)])

def parse_lariat_reads(lariat_table, read_len, tmp_path):

	lariats = []
	with open(lariat_table) as in_file:
		with open(tmp_path, 'w') as out_file:
			for line in in_file:
				items = line.strip().split('\t')
				items[3] = items[3].upper()
				try:
					seq, chrom, strand, fivep, _, bp, bp_seq = items[3:10]
				except:
					print(items)
					print(line)
					print(len(lariats))
					continue

				if strand == '+':
					ref_start, ref_end = int(bp)-read_len, int(fivep)+read_len
					out_file.write('{}\t{}\t{}\thead\t0\t+\n'.format(chrom, ref_start, bp))
					out_file.write('{}\t{}\t{}\ttail\t0\t+\n'.format(chrom, fivep, ref_end))
				else:
					ref_start, ref_end = int(bp)+read_len, int(fivep)-read_len
					out_file.write('{}\t{}\t{}\thead\t0\t-\n'.format(chrom, bp, ref_start))
					out_file.write('{}\t{}\t{}\ttail\t0\t-\n'.format(chrom, ref_end, fivep))

				lariats.append(items)

	return lariats

def parse_genomic_sequences(lariats, seq_file):

	genomic_seqs = []
	with open(seq_file) as in_file:
		head_line = in_file.readline().strip()
		tail_line = in_file.readline().strip()
		while head_line:
			head_seq, tail_seq = head_line.split('\t')[1], tail_line.split('\t')[1]
			genomic_seq = head_seq.upper()+tail_seq.upper()
			genomic_seqs.append(genomic_seq)
			
			head_line = in_file.readline().strip()
			tail_line = in_file.readline().strip()

	return genomic_seqs

def find_genomic_BP_seq(lariats, genomic_seqs, read_len):

	out_lines = []
	global lariats_done

	for i in range(len(lariats)):
		
		curr_lar, genomic_seq = lariats[i], genomic_seqs[i]
		read_seq, read_len = curr_lar[3], len(curr_lar[3])

		sub_seqs = [genomic_seq[i:i+read_len] for i in range(len(genomic_seq)+1-read_len)]
		sub_dists = [distance(read_seq,sub) for sub in sub_seqs]
		closest_sub = min(range(len(sub_seqs)), key=lambda i: sub_dists[i])
		if sub_dists[closest_sub] <= 3:
			sub_start = int(len(genomic_seq)/2-closest_sub-5)
			bp_substr = read_seq[sub_start:sub_start+10]
			out_lines.append('\t'.join(curr_lar+[read_seq,bp_substr,curr_lar[9]])+'\n')
		else:
			rev_seq = reverse_complement(read_seq)
			sub_dists = [distance(rev_seq,sub) for sub in sub_seqs]
			closest_sub = min(range(len(sub_seqs)), key=lambda i: sub_dists[i])
			if sub_dists[closest_sub] <= 3:
				sub_start = int(len(genomic_seq)/2-closest_sub-5)
				bp_substr = rev_seq[sub_start:sub_start+10]
				out_lines.append('\t'.join(curr_lar+[rev_seq,bp_substr,curr_lar[9]])+'\n')
			else:
				print('Error:\n'+'\t'.join(curr_lar))

		lariats_done += 1
		if lariats_done % 1000 == 0:
			print(time.strftime('%m-%d %H:%M:%S') + ' - Done getting genomic BP sequence for {} lariats'.format(lariats_done))

	return out_lines


if __name__ == '__main__':

	lariat_table, genome_fasta, read_len, thread_num = sys.argv[1:]
	read_len, thread_num = int(read_len), int(thread_num)

	tmp_bed, tmp_seq = 'lariat_read_genomic_coords_tmp.bed', 'lariat_read_genomic_coords_tmpseq.txt'
	lariats = parse_lariat_reads(lariat_table, read_len, tmp_bed)
	run(['bedtools', 'getfasta', '-fi', genome_fasta, '-tab', '-s', '-nameOnly', '-bed', tmp_bed, '-fo', tmp_seq])
	genomic_seqs = parse_genomic_sequences(lariats, tmp_seq)
	run(['rm', tmp_bed, tmp_seq])
	assert len(lariats) == len(genomic_seqs)
	
	split_indices = [0]+[int(len(lariats)*(i/float(thread_num))) for i in range(1,thread_num+1)]
	threads = []
	for i in range(1,thread_num+1):
		start, stop = split_indices[i-1], split_indices[i]
		lar_sub, seq_sub = lariats[start:stop], genomic_seqs[start:stop]
		new_thread = mut_thread(lar_sub, seq_sub, read_len)
		new_thread.start()
		print('Started thread {}'.format(i))
		threads.append(new_thread)

	for t in threads:
		t.join()

	out_lines = [t.out_lines for t in threads]
	with open(lariat_table.replace('.txt', '_wReadSeq_test.txt'), 'w') as out_file:
		for line_list in out_lines:
			for line in line_list:
				out_file.write(line)
	

