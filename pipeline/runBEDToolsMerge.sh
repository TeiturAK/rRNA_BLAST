#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error
set -eux

#Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

module load bioinfo-tools BEDTools

in=$1

out=${in/.bed/.merged.bed}

## merge files
bedtools sort -i $in | bedtools merge -i - > $out
