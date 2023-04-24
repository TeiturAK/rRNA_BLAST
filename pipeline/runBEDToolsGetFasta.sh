#!/bin/bash -l
#SBATCH --mail-type=ALL

## stop on error
set -eux

#Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

module load bioinfo-tools BEDTools

bed=$1
shift

fasta=$1
shift

out=$1
shift

params=$@

## Run
#Usage:   bedtools getfasta [OPTIONS] -fi <fasta> -bed <bed/gff/vcf>
bedtools getfasta $params -fi $fasta -bed $bed > $out
