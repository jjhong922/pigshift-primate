#!/usr/bin/python

# Load required modules
import sys, os, argparse, numpy as np

# Parse the arguments
parser = argparse.ArgumentParser(description='')
parser.add_argument('-i', '--input_file', default='')
parser.add_argument('-gcf', '--gene_conversion_file', default='human-ensemblToSymbol-map.txt')
parser.add_argument('--species', default=[ 'hsa', 'ptr', 'ggo', 'ppy', 'mml'], nargs='*', choices=[ 'hsa', 'ptr', 'ggo', 'ppy', 'mml', 'mmu' ])
parser.add_argument('--organ', default='br', choices=['br', 'kd', 'ht', 'lv', 'ts', 'cb'])
parser.add_argument('--gender', default='M', choices=['M', 'F'])
parser.add_argument('--replicate', default='1', choices=map(str, range(1, 6)))
parser.add_argument('-o', '--output_file', required=True)
args = parser.parse_args(sys.argv[1:])

# Hard-code conversion
speciesToName = dict(hsa='human', ptr='chimp', ggo='gorilla', ppy='orangutan', mml='monkey', mmu='mouse')
organToName   = dict(br='brain', kd='kidney', lv='liver', ts='testis', ht='heart', cb='cerebellum')

# Load gene conversion
with open(args.gene_conversion_file) as f:
        arrs = [ l.rstrip('\n').split() for i, l in enumerate(f) if i > 0 ]
        ensemblToSymbol = dict( (arr[0], arr[1] if len(arr) == 2 else arr[0]) for arr in arrs )

# Load the raw data
rowNames    = [ ' '.join([s, args.organ, args.gender, args.replicate]) for s in args.species ]
rowLabels   = [ speciesToName[s] for s in args.species ]
colNames    = []
nonNullCols = []
with open(args.input_file) as f:
	arrs    = [ l.rstrip().split('\t') for l in f ]
	header  = arrs.pop(0)
	indices = [ header.index(label) for label in rowNames ]
	A = np.zeros((len(rowNames), len(arrs)))
	for colIndex, arr in enumerate(arrs):
		vals = np.array([ float(arr[i]) for i in indices ], dtype=np.float64)
		if not any(vals == 0) and not any(np.isnan(vals)):
			# Compute log2 fold change relative to the first species
			# vals = np.log2(vals / vals[0])

			# Add the columna and label
			nonNullCols.append( colIndex ) # keep track of columns to keep
			A[:, colIndex] = vals

                        # Colnames are HUMAN Ensembl gene names, which we convert to symbols
                        if arr[0] in ensemblToSymbol:
                                colNames.append(ensemblToSymbol[arr[0]])
                        else:
                                colNames.append(arr[0])

# Write to file
A = A[:, nonNullCols]
print '{} genes in {} species'.format(len(colNames), len(rowNames))
with open(args.output_file, 'w') as out:
	output = [ '{}\t{}'.format(label, '\t'.join(map(str, A[i, :]))) for i, label in enumerate(rowLabels) ]
	out.write('\t' + '\t'.join(colNames) + '\n')
	out.write('\n'.join(output))
