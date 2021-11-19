#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/plant_tRNA-id90.fasta
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/ClustalOmega/plant_tRNA-id90.st

outdir=$(dirname $out)
if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

fnam=$(basename ${in/.fasta/})
sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p node -N 1 -n 20 runClustalOmega.sh $in $out -v --outfmt=st
