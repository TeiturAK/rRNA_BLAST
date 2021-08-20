#!/bin/bash -l
#SBATCH --partition=core
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=6000
#SBATCH --nodelist=picea
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -e -x

# load the modules
module load bioinfo-tools blast/2.6.0+

export BLASTDB_LMDB_MAP_SIZE=100000000

in=$1
out=$2

# run the command
makeblastdb -in $in -dbtype nucl -out $out

