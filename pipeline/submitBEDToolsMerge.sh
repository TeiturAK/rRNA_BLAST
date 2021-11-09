#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=u2019003
mail=teitur.kalman@umu.se

in=/mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-chromosomes_4-Nov-2021
out=/mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-chromosomes_4-Nov-2021

## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

for f in $(find $in -name "*.bed"); do
  fnam=$(basename $f).merge_bed
  sbatch -A $proj -t 30:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
  -J $fnam -p node -n 1 runBEDToolsMerge.sh $f
done

