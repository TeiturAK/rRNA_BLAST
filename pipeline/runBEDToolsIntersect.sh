#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error
set -eux

#Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

module load bioinfo-tools BEDTools

a_file=$1
shift
b_file=$1
shift
out=$1
shift
params=$@

## Run
bedtools intersect $params -a $a_file -b $b_file > $out
