#!/bin/bash

## be verbose and print
set -eux

#proj=snic2021-5-312
proj=snic2022-5-342
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

fasta=/crex/proj/uppstore2017145/V2/users/teitu/fasta_w-MT-and-CP/original/pabies-2.0_chromosomes_and_unplaced.fa
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/barrnap_14_dec_2022

fnam=$(basename $fasta).barrnap

if [ ! -d $out ]; then
	mkdir -p $out
fi

# Usage:
#   barrnap [options] chr.fa
#   barrnap [options] < chr.fa
#   barrnap [options] - < chr.fa
# Options:
#   --help            This help
#   --version         Print version and exit
#   --citation        Print citation for referencing barrnap
#   --kingdom [X]     Kingdom: bac mito arc euk (default 'bac')
#   --quiet           No screen output (default OFF)
#   --threads [N]     Number of threads/cores/CPUs to use (default '1')
#   --lencutoff [n.n] Proportional length threshold to label as partial (default '0.8')
#   --reject [n.n]    Proportional length threshold to reject prediction (default '0.25')
#   --evalue [n.n]    Similarity e-value cut-off (default '1e-06')
#   --incseq          Include FASTA _input_ sequences in GFF3 output (default OFF)
#   --outseq [X]      Save rRNA hit seqs to this FASTA file (default '')

sbatch -A $proj -t 2-00:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 20 runBarrnap.sh $fasta $out/rRNA.gff --threads 20 --kingdom euk --outseq $out/rRNA.fa
