#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/fasta/plant_tRNA-id90.fasta
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/RCoffee

if [ ! -d $out ]; then
	mkdir -p $out
fi

fnam=$(basename ${in/.f*a/})
sbatch -A $proj -t 48:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 20 -C mem512GB runRCoffee.sh $in $out
