#!/bin/bash

## be verbose and print
set -eux

proj=u2019003
mail=teitur.kalman@umu.se


## source functions
source ../UPSCb-common/src/bash/functions.sh

query=/mnt/picea/home/tkalman/rRNA/rRNA_seq/Picea-Pinus_5.8-rRNA-subunits.fa
db_basename=/mnt/picea/home/tkalman/rRNA/BLAST_DB/pabies-2.0_chromosomes_and_unplaced.db
out=/mnt/picea/home/tkalman/rRNA/BLAST_results/Picea-Pinus_5.8-rRNA-subunits__BLASTn__pabies-2.0_chromosomes_and_unplaced.out

fnam=$(basename $query)
outdir=$(dirname $out)

if [ ! -d $outdir ]; then
        mkdir -p $outdir
fi

echo sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p core runBLASTn.sh $query $db_basename $out
