#!/bin/bash

## be verbose and print
set -eux

proj=snic2022-5-342
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

fasta=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/barrnap_14_dec_2022/rRNA.fa
#out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/cd-hit
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/cd-hit_cluster-size-sorted

fnam=$(basename ${fasta/.fa/.cd-hit})

if [ ! -d $out ]; then
	mkdir -p $out
fi

sbatch -A $proj -t 2-00:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 20 runCD-HIT.sh $fasta $out/$fnam.fa -c 0.9 -n 5 -T 20 -d 0 -g 1 -sc
