#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

# load the modules
#module load bioinfo-tools infernal/1.1.2 tRNAscan-SE/2.0.9
module load bioinfo-tools infernal/1.1.2 tRNAscan-SE/2.0.9

fasta=$1
shift
out=$1
shift 
params=$@

# run 
tRNAscan-SE --thread 20 $params -o $out $fasta
