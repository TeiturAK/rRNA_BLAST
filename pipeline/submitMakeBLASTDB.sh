#!/bin/bash

## be verbose and print
set -eux

proj=snic2022-5-342
mail=teitur.kalman@umu.se

module load bioinfo-tools blast/2.12.0+

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V2/reference/Picea-abies/v2.0/fasta/Picab02_chromosomes_and_unplaced.fa.gz
out=/crex/proj/uppstore2017145/V2/users/teitu/rRNA_tRNA/blast_db

fnam=$(basename ${in/.fa.gz/})

if [ ! -d $out ]; then
    mkdir -p $out
fi

#Usage: $0 [options] <fasta file> <out dir>
#    Options:
#            -p the type of file nucl/prot (default to nucl)
#            -t the db title

sbatch -A $proj -t 3-00:00:00 --mail-user=$mail -e $out/$fnam.err -o $out/$fnam.out \
-J $fnam -p core -n 20 ../UPSCb-common/pipeline/runBlastPlusMakeblastdb.sh -p nucl -t $fnam $in $out
