#!/bin/bash

## be verbose and print
set -eux

proj=facility
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

mask_ref=/mnt/picea/home/tkalman/rRNA_facility/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90.fa
in=/mnt/picea/home/tkalman/rRNA_facility/fasta
out=/mnt/picea/home/tkalman/rRNA_facility/repeatmasker_test


for f in $(find $in -name "pabies_2.0_chromosomes.part_006.part_001.fasta"); do

	fnam=$(basename $f)

	if [ ! -d $out/$fnam ]; then
		mkdir -p $out/$fnam
	fi

	sbatch -A $proj -t 2-00:00:00 --mail-user=$mail -e $out/$fnam/$fnam.err -o $out/$fnam/$fnam.out \
	-J $fnam -p node -N 1 -n 20 runRepeatMasker.sh $mask_ref $f $out/$fnam
done
