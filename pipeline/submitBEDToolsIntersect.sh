#!/bin/bash

## be verbose and print
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

module load bioinfo-tools BEDTools

## variables
proj=facility
mail=teitur.kalman@umu.se

a=/mnt/picea/home/tkalman/rRNA_facility/sliding-window/P.abies/Pabies.10000bp-windows.bed
b_dir=/mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-chromosomes_4-Nov-2021

out=/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect

bed_params="-wao"

## create the out dir
if [ ! -d $out ]; then
    mkdir -p $out
fi

for b in $(find $b_dir -name "*.merged.bed"); do
  fnam=$(basename $a)_$(basename $b)
  sbatch -A $proj -t 30:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
  -J $fnam -p node -n 1 ../UPSCb-common/pipeline/runBedToolsIntersect.sh $a $b $out $bed_params
done

