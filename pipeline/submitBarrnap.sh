#!/bin/bash

## be verbose and print
set -eux

#proj=snic2021-5-312
proj=snic2022-5-342
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

#fasta=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa
#out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/barrnap_9_may_2022

fasta=/crex/proj/snic2020-16-250/ATAC-seq/data/aspen/fasta/Potra02_genome/Potra02_genome.fasta
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/barrnap_aspen-run-for-comparison_24_nov_2022

#fasta=
#out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/barrnap_arabidopsis-run-for-comparison_24_nov_2022


fnam=$(basename $fasta)

#outdir=$(dirname $out)

if [ ! -d $out ]; then
	mkdir -p $out
fi

sbatch -A $proj -t 2-00:00:00 --mail-user=$mail -e $out/barrnap.err -o $out/barrnap.out \
-J $fnam -p core -n 20 runBarrnap.sh $fasta $out


