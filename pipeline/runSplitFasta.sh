#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

# load the modules
module load bioinfo-tools SeqKit/0.15.0

fasta=$1
shift
out=$1
shift
params=$@

# run the command
seqkit split $params -O $out/$(basename $fasta).split $fasta

