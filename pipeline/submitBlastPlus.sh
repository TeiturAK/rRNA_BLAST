#!/bin/bash

## be verbose and print
set -eux

proj=facility
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/mnt/picea/home/tkalman/rRNA/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90_split-fasta
db_basename=/mnt/picea/home/tkalman/rRNA/BLAST_DB/pabies-2.0_chromosomes_and_unplaced.fa/pabies-2.0_chromosomes_and_unplaced.fa.db
out=/mnt/picea/home/tkalman/rRNA/BLAST_results/Picea-Pinus__BLASTn__pabies-2.0_chromosomes_and_unplaced_12-Aug-2021

for f in $(find $in -name "*.fa"); do
  fnam=$(basename $f)

  outdir=$out/$fnam

  if [ ! -d $outdir ]; then
        mkdir -p $outdir
  fi

  sbatch -A $proj -t 3:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
  -J $fnam -p core runBlastPlus.sh blastn $f $db_basename $outdir
done


#Usage: $0 [options] <blast command> <fasta file> <index> <out dir>
#
#        Options:
#                -f the output format (default to $FMT)
#                -e the e-value (default to $EVALUE)
#                -p number of threads to use (default $PROC)
#                -b blast options (example -task blastn instead of megablast)

#sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
#-J $fnam -p rbx runBlastPlus.sh blastn $query $db_basename $out
