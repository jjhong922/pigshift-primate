#!/usr/bin/python

# Load required modules
import sys, os, argparse
from collections import defaultdict

# Parse arguments
parser = argparse.ArgumentParser(description='')
parser.add_argument('-i', '--input_file', help='Input GO file in OWL format.', type=str, required=True)
parser.add_argument('-o', '--output_file', type=str, required=True)
args = parser.parse_args(sys.argv[1:])

# Load the GO network
goTerms = defaultdict(set)
with open(args.input_file) as f:
    for i, l in enumerate(f):
        if l.startswith('!'): continue
        arr = l.rstrip('\n').split('\t')
        goTerms[arr[4]].add( arr[2] )

# Output in a friendlier format
with open(args.output_file, 'w') as out:
    out.write( '\n'.join([ '{}\t{}'.format(n, '\t'.join(sorted(genes))) for n, genes in goTerms.iteritems() ]) )
