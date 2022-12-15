#!/bin/bash

## be verbose and print
set -eux

proj=snic2022-5-342
#proj=uppmax2020-2-4
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

fasta=/crex/proj/uppstore2017145/V2/users/teitu/fasta_w-MT-and-CP/original/pabies-2.0_chromosomes_and_unplaced.fa
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/tRNAscan-SE_Legacy-mode

fnam=$(basename $fasta).trnascan

if [ ! -d $out ]; then
	mkdir -p $out
fi

sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p node -N 1 runtRNAscan-SE.sh $fasta $out/results -E -L --log $out/log --gff $out/tRNA.gff --bed $out/tRNA.bed --missed $out/missed --hitsrc --progress

#out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/tRNAscan-SE_Infernal-mode

#if [ ! -d $out ]; then
#        mkdir -p $out
#fi

#sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
#-J $fnam -p node -N 1 runtRNAscan-SE.sh $fasta $out/results -E -I --log $out/log --gff $out/tRNA.gff --bed $out/tRNA.bed --missed $out/missed --hitsrc --progress --thread 20

