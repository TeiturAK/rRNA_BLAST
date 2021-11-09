#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

mask_ref=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/rRNA_seq/Picea_Pinus_rRNA_subunits.merge_id90.fa
#in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/fasta_split_chromosomes/pabies_2.0_chromosomes.fasta.gz/pabies_2.0_chromosomes.fasta.gz.split
in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/fasta/fasta_unplaced
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/RepeatMasker_only_unplaced_5Nov2021


for f in $(find $in -name "*.fasta"); do

	fnam=$(basename $f)

	if [ ! -d $out/$fnam ]; then
		mkdir -p $out/$fnam
	fi

	sbatch -A $proj -t 4-00:00:00 --mail-user=$mail -e $out/$fnam/$fnam.err -o $out/$fnam/$fnam.out \
	-J $fnam -p node -N 1 -n 20 -C mem128GB runRepeatMasker.sh $mask_ref $f $out/$fnam
done
