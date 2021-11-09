#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90.fa
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/fasta-split/Picea-abies
params="-p 8 -2"

module load bioinfo-tools infernal/1.1.2


fnam=$(basename $in)
outdir=$out/$fnam

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 00:30:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p node -N 1 -n 20 runSplitFasta.sh $in $outdir $params

