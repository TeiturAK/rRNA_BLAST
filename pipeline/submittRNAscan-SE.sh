#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

fasta=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/tRNAscan-SE_9-May/results

fnam=$(basename $fasta)
outdir=$(dirname $out)

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 5-00:00:00 --mail-user=$mail -e $outdir/tRNAscan.err -o $outdir/tRNAscan.out \
-J $fnam -p core -n 20 runtRNAscan-SE.sh $fasta $out --max --gff --progress


