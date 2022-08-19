#!/bin/bash

## be verbose and print
set -eux

#proj=snic2021-5-312
proj=uppmax2020-2-4
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

fasta=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa
#out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/tRNAscan-SE_28-June_2
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/tRNAscan-SE_28-June_snowy_3-legacy


fnam=$(basename $fasta)

if [ ! -d $out ]; then
	mkdir -p $out
fi

#sbatch -A $proj -t 10-00:00:00 --mail-user=$mail -e $out/tRNAscan.err -o $out/tRNAscan.out \
#-J $fnam -p node -N 3 runtRNAscan-SE.sh $fasta $out/results -I --thread 60 --gff $out/results.gff --bed $out/results.bed --hitsrc --progress 


sbatch -A $proj -t 10-00:00:00 --mail-user=$mail -e $out/tRNAscan.err -o $out/tRNAscan.out \
-J $fnam -p node -N 1 -M snowy --qos=gpu runtRNAscan-SE.sh $fasta $out/results -L --gff $out/results.gff --bed $out/results.bed --hitsrc --progress
