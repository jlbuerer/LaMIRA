import sys
from os.path import join

def parse_exons(anno_file):

	tx_exons = {}
	with open(anno_file) as in_file:
		for line in in_file:
			if line[0] != '#':
				chrom, _, feat, start, end, _, strand, _, info = line.strip().split('\t')

				if feat == 'exon':

					info = {e.split(' ')[0]:e.split(' ')[1].replace('\"', '') for e in info[:-1].split('; ')}
					tx_id = info['transcript_id']
					if tx_id not in tx_exons:
						tx_exons[tx_id] = []
					tx_exons[tx_id].append((chrom, int(start)-1, int(end), strand))

	return tx_exons

def output_tables(tx_exons, ss_file, intron_file):

	with open(ss_file, 'w') as ss_out:
		with open(intron_file, 'w') as intron_out:
			for tx_id in tx_exons:
				sorted_exons = sorted(tx_exons[tx_id], key=lambda e:e[1])
				chrom, strand = sorted_exons[0][0], sorted_exons[0][-1]
				starts, ends = [e[1] for e in sorted_exons], [e[2] for e in sorted_exons]
				tx_start, tx_end = min(starts), max(ends)
				ss_out.write('{}\t{}\t{}\t{}\t{}\t{}\t{},\t{},\n'.format(tx_id, chrom, strand, tx_start, tx_end, len(sorted_exons), ','.join([str(e) for e in starts]), ','.join([str(e) for e in ends])))

				for i in range(1,len(sorted_exons)):
					
					intron_start, intron_end = sorted_exons[i-1][2], sorted_exons[i][1]
					intron_out.write('{}\t{}\t{}\t{}\t{}\t{}\n'.format(chrom, intron_start, intron_end, tx_id+'_intron_{}'.format(i), 0, strand))

if __name__ == '__main__':

	anno_file, genome_path = sys.argv[1:]

	output_tables(parse_exons(anno_file), genome_path+'_ss_table.txt', genome_path+'_introns.bed')

					






