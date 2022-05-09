#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

## source functions
source ../UPSCb-common/src/bash/functions.sh

# load the modules
module load bioinfo-tools barrnap/0.9

fasta=$1
shift
out=$1

# run 
# barrnap [options] chr.fa
barrnap --threads 20 --kingdom euk --incseq $fasta > $out/rrna.gff
