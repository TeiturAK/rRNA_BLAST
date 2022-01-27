#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error and be verbose in the output
set -eux

## Copied from https://www.tcoffee.org/Projects/tcoffee/workshops/tcoffeetutorials/rna-alignment/r-coffee.html

## load the modules
module load bioinfo-tools T-Coffee/11.00.8cbe486

fasta=$1
out=$2

fnam=$(basename "${fasta/.f*a/}")

CACHE_4_TCOFFEE=$TMPDIR/$fnam/cache
LOCKDIR_4_TCOFFEE=$TMPDIR/$fnam/lock
TMP_4_TCOFFEE=$TMPDIR/$fnam/tmp

mkdir -p $CACHE_4_TCOFFEE
mkdir -p $LOCKDIR_4_TCOFFEE
mkdir -p $LOCKDIR_4_TCOFFEE

## run
cd $out
#t_coffee -reg -seq $fasta -mode rcoffee -outfile $out/$fnam.aln
t_coffee -seq $fasta -mode rcoffee -method=slow_pair,lalign_id_pair -distance_matrix_mode=idscore -dp_mode=myers_miller_pair_wise -outfile $out/$fnam.aln
t_coffee -other_pg=seq_reformat -in $out/$fnam.aln -action +add_alifold -output stockholm_aln -out $out/$fnam.sto
