#!/bin/bash -l
#SBATCH --partition=core
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH --nodelist=picea
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -e -x

# load the modules
module load bioinfo-tools blast/2.6.0+

query=$1
db_basename=$2
out=$3

# run the command
blastn -query $query -db $db_basename -out $out

