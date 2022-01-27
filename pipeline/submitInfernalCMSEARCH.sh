#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cm
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cmsearch.txt
fasta=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa.gz

fnam=$(basename $in)
outdir=$(dirname $out)

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.cmsearch.err -o $outdir/$fnam.cmsearch.out \
-J $fnam -p core -n 20 runInfernalCMSEARCH.sh $in $out $fasta

