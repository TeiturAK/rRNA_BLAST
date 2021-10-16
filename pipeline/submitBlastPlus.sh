#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

#in=/crex/proj/uppstore2017145/V3/blast/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90_split-fasta

in=/crex/proj/uppstore2017145/V3/blast/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90.fa

db_basename=/crex/proj/uppstore2017145/V3/blast/blast_DB/Picea-abies/pabies-2.0_chromosomes_and_unplaced.fa.db
out=/crex/proj/uppstore2017145/V3/blast/blast_results/Picea-abies/Picea-Pinus__BLASTn__pabies-2.0_chromosomes_and_unplaced_26-Aug-2021

#for f in $(find $in -name "*.fa"); do
#  fnam=$(basename $f)
#
#  outdir=$out/$fnam
#
#  if [ ! -d $outdir ]; then
#        mkdir -p $outdir
#  fi
#
#  sbatch -A $proj -t 3:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
#  -J $fnam -p node -N 10 -n 40 -C mem128GB runBlastPlus.sh blastn $f $db_basename $outdir
#done


#Usage: $0 [options] <blast command> <fasta file> <index> <out dir>
#
#        Options:
#                -f the output format (default to $FMT)
#                -e the e-value (default to $EVALUE)
#                -p number of threads to use (default $PROC)
#                -b blast options (example -task blastn instead of megablast)

fnam=$(basename $in)
outdir=$out/$fnam

if [ ! -d $outdir ]; then
	mkdir -p $outdir
fi

sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
-J $fnam -p node -N 20 -n 80 -C mem128GB runBlastPlus.sh blastn $in $db_basename $outdir

