#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=snic2022-5-342
mail=teitur.ahlgren.kalman@umu.se

bed=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/tRNAscan-SE_Infernal-mode/tRNA.bed
fasta=/crex/proj/uppstore2017145/V2/users/teitu/fasta_w-MT-and-CP/original/pabies-2.0_chromosomes_and_unplaced.fa
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/tRNAscan-SE_Infernal-mode_BEDTools-getfasta

## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

fnam=$(basename ${bed/.bed/})

sbatch -A $proj -t 04:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 10 runBEDToolsGetFasta.sh $bed $fasta $out/$fnam.fa -s -nameOnly


