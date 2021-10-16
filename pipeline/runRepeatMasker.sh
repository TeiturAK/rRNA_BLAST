#!/bin/bash -l

## stop on error
set -e

## be verbose and extend the commands
set -x

## load the modules
module load bioinfo-tools
module load RepeatMasker/4.0.7

#Usage: RepeatMasker [-options] <seqfiles(s) in fasta format>

mask_ref=$1
fasta=$2
out=$3

cd $out

RepeatMasker -nolow -qq -lib $mask_ref -dir $out -html $fasta



