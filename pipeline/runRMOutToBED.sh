#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error
set -eux

#Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

in=$1

out=${in/ori.out/bed}

## convert from RepeatMasker out file to bed format
awk '{print $5"\t"$6"\t"$7"\t"$10}' $in > $out
