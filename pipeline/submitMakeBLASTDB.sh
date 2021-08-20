#!/bin/bash

## be verbose and print
set -eux

proj=u2019003
mail=teitur.kalman@umu.se


## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/mnt/picea/home/tkalman/rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa
out=/mnt/picea/home/tkalman/rRNA/BLAST_DB

#for f in $(find $in -name "*.fa"); do
#  fnam=$(basename $f)
#  outdir=$out/$fnam
#
#  if [ ! -d $outdir ]; then
#    mkdir -p $outdir
#  fi

#  sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out \
#  -J $fnam -p core runMakeBLASTDB.sh $f $outdir/$fnam.db
#done

fnam=$(basename $in)
outdir=$out/$fnam

if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi


sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $outdir/$fnam.err -o $outdir/$fnam.out -J $fnam -p core runMakeBLASTDB.sh $in $outdir/$fnam.db
