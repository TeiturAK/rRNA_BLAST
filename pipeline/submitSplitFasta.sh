#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/pabies-2.0_chromosomes.fasta.gz
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/fasta-split_chromosomes

params="-p 8 -2"

fnam=$(basename $in)
outdir=$out/$fnam

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 3:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p node -N 1 -n 20 runSplitFasta.sh $in $outdir $params

