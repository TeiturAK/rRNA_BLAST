#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

## variables
proj=facility
mail=teitur.kalman@umu.se

in=/mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-unplaced_4-Nov-2021
out=/mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-unplaced_4-Nov-2021
## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

## execute PE
for f in $(find $in -name "*.ori.out"); do
  fnam=$(basename $f).RMOutToBED
  sbatch -A $proj -t 30:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
  -J $fnam -p node -n 1 runRMOutToBED.sh $f
done

