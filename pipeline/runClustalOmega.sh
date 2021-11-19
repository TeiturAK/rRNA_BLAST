#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

# load the modules
module load bioinfo-tools clustalo/1.2.4

fasta=$1
shift
out=$1
shift
params=$@

# run the command
clustalo -i $fasta -o $out $params
