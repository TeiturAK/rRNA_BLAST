#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=facility
mail=teitur.kalman@umu.se

in=/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect
out=/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect

## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

for f in $(find $in -name "*.tsv"); do
  fnam=$(basename $f).collapse_intersect
  sbatch -A $proj -t 30:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
  -J $fnam -p node -n 1 runCollapseWindows.sh $f
done

