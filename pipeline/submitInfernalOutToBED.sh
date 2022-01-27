#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cmsearch.txt
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cmsearch.sorted.bed

fnam=$(basename $in).InfernalOutToBED
outdir=$(dirname $out)

if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

sbatch -A $proj -t 05:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p core -n 1 runInfernalOutToBED.sh $in $out


