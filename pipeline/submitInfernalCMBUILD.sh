#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/RCoffee/tRNA-id90.sto
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cm

fnam=$(basename $in)
outdir=$(dirname $out)

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 06:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p core -n 20 runInfernalCMBUILD.sh $in $out

