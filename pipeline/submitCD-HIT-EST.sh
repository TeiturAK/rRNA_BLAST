#!/bin/bash

## be verbose and print
set -eux

proj=snic2022-5-342
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

#fasta=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/barrnap_14_dec_2022/rRNA.fa
#out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/rRNA_seq/cd-hit-est

fasta=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/tRNAscan-SE/tRNA.fa
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/tRNA_seq/cd-hit-est

fnam=$(basename ${fasta/.fa/.cd-hit-est})

if [ ! -d $out ]; then
	mkdir -p $out
fi

sbatch -A $proj -t 03:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 10 runCD-HIT-EST.sh $fasta $out/$fnam.fa
