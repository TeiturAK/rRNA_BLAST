#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

a_file=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/sliding_window/Pabies.10000bp-windows.bed
b_file=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cmsearch.sorted.bed
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/intersect

## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

fnam=$(basename $a_file).bedtools-intersect.$(basename $b_file)
sbatch -A $proj -t 30:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 10 runBEDToolsIntersect.sh $a_file $b_file $out/$fnam.tsv -wao


