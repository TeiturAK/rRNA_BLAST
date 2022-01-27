#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

# load the modules
module load bioinfo-tools infernal/1.1.2

in=$1
out=$2
fasta=$3

# run 
cmsearch -o $out $in $fasta
