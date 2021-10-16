#!/bin/bash

## be verbose and print
set -eux

proj=facility
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

mask_ref=/mnt/picea/home/tkalman/rRNA/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90.fa
fasta=/mnt/picea/home/tkalman/rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa
out=/mnt/picea/home/tkalman/rRNA/RepeatMasker_results_15-Sept-2021

fnam=$(basename $fasta)

if [ ! -d $out ]; then
  mkdir -p $out
fi

sbatch -A $proj --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p nolimit runRepeatMasker.sh $mask_ref $fasta $out
