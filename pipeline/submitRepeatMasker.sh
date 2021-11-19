#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

#mask_ref=/mnt/picea/home/tkalman/rRNA_facility/rRNA_seq/Picea-Pinus_rRNA-subunits.merge-id90.fa
mask_ref=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/Picea_Pinus_rRNA_subunits.merge_id90.revcomp.fa

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/fasta_unplaced

out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/RepeatMasker_only-unplaced_revcomp_16-Nov-2021


for f in $(find $in -name "*.fasta"); do

	fnam=$(basename $f)

	if [ ! -d $out/$fnam ]; then
		mkdir -p $out/$fnam
	fi

	sbatch -A $proj -t 2-00:00:00 --mail-user=$mail -e $out/$fnam/$fnam.err -o $out/$fnam/$fnam.out \
	-J $fnam -p node -N 1 -n 20 runRepeatMasker.sh $mask_ref $f $out/$fnam
done
