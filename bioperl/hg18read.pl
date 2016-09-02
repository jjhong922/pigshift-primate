#!/usr/local/bin/perl
use strict;
#use Bio::Tools::RNAMotif;
use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::FeatureIO;

my $featureio = Bio::FeatureIO -> new(-file => "../seq_data/2xHARs.bed", -format => "bed");

while(my $curfeature = $featureio -> next_feature) {
	print $curfeature."\n";
}

print 'end';

