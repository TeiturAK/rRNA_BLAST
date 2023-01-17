#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

# load the modules
module load bioinfo-tools cd-hit/4.8.1

fasta=$1
shift

out=$1
shift

options=$@

# run 
# Usage: cd-hit-est [Options]

cd-hit-est -i $fasta -o $out $options

