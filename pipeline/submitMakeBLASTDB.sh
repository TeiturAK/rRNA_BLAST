#!/bin/bash

## be verbose and print
set -eux

proj=facility
mail=teitur.kalman@umu.se


## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/mnt/picea/home/tkalman/FOR-ANALYSIS-IN-ALL-PHD-PROJECTS/fasta/Potra02_genome_with_chloroplast_and_mitochondrion.fasta.gz
out=/mnt/picea/home/tkalman/FOR-ANALYSIS-IN-ALL-PHD-PROJECTS/BLAST_DB

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
