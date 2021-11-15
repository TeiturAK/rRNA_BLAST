#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error
set -eux

#Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

module load bioinfo-tools BEDTools

in=$1

out=${in/.tsv/.collapsed.bed}

## merge files
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$7}' $in | bedtools sort -i - | bedtools merge -d -2 -c 5 -o sum -i - > $out
