#!/bin/bash

################################################################################
# SETTINGS, FILES, AND DIRECTORIES
################################################################################

# Settings

# Directories
PROJECT_DIR=`pwd`

OUTPUT_DIR=$PROJECT_DIR/output
mkdir -p $OUTPUT_DIR/primate-female-{br,cb,ht,kd} $OUTPUT_DIR/primate-male-{br,ht,kd,lv}

DATA_DIR=$PROJECT_DIR/data
MISC_DIR=$DATA_DIR/misc
GO_DIR=$DATA_DIR/go 
HUMAN_GO_DIR=$GO_DIR/human
EXPRESSION_DIR=$DATA_DIR/expression
PRIMATE_EXPRESSION_DIR=$EXPRESSION_DIR/primate

mkdir -p $HUMAN_GO_DIR $PRIMATE_EXPRESSION_DIR

# Files
HUMAN_ENSEMBL_SYMBOL_MAP=$MISC_DIR/human-ensembl-hgnc-symbol-map.txt
BRAWAND_PRIMATE_TREE=$MISC_DIR/brawand-et-al-primate-tree.tre

################################################################################
# DOWNLOAD AND PREPROCESS DATA
################################################################################

# Download human GO terms, then process into a simple adjacency list format
cd $HUMAN_GO_DIR
echo $PWD
wget http://geneontology.org/gene-associations/gene_association.goa_human.gz
gunzip gene_association.goa_human.gz
python parseGO.py -i gene_association.goa_human -o human-go-terms.txt

# Download the data from the Brawand, et al. paper and preprocess it
BRAWAND_DIR=$PRIMATE_EXPRESSION_DIR/brawand-et-al
BRAWAND_MATRICES_DIR=$BRAWAND_DIR/matrices
mkdir -p $BRAWAND_MATRICES_DIR
cd $BRAWAND_DIR

wget http://www.nature.com/nature/journal/v478/n7369/extref/nature10532-s4.zip
unzip nature10532-s4.zip
rm -r nature10532-s4.zip __MACOSX

BRAWAND_EXPR=$BRAWAND_DIR/Supplementary_Data1/NormalizedRPKM_ConstitutiveExons_Primate1to1Orthologues.txt
for organ in br kd ht lv
do
	python logFoldChanges.py -i $BRAWAND_EXPR --organ ${organ} --gender M \
		-gcf $HUMAN_ENSEMBL_SYMBOL_MAP -o matrices/primate-male-${organ}.tsv
done

for organ in br kd ht cb
do
	python logFoldChanges.py -i $BRAWAND_EXPR  --organ ${organ} --gender F \
		-gcf $HUMAN_ENSEMBL_SYMBOL_MAP -o matrices/primate-female-${organ}.tsv
done
