#!/bin/bash

## be verbose and print
set -eux

proj=snic2021-5-312
mail=teitur.ahlgren.kalman@umu.se

## source functions
source ../UPSCb-common/src/bash/functions.sh

in=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal/tRNA-id90.cm
out=/crex/proj/uppstore2017145/V3/blast/rRNA_tRNA/tRNA_seq/Infernal

fnam=$(basename $in)

sbatch -A $proj -t 24:00:00 --mail-user=$mail -e $out/$fnam.cmcalibrate.err -o $out/$fnam.cmcalibrate.out \
-J $fnam -p core -n 20 runInfernalCMCALIBRATE.sh $in

