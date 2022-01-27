#!/bin/bash -l
#SBATCH --mail-type=ALL

## Stop on error
set -eux

# Load functions
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

# Load modules
module load bioinfo-tools BEDTools

in=$1
out=$2

## Convert from Infernal cmsearch out file to bed format
# Keep only matches with e-value below thresh 
# Use the cmsearch e-value as score for bedtrack
# Change order of second and third column if second is > third
# Sort with bedtools sort and write to file

DATA_BEGIN=" ------   --------- ------ -----  ---------------- ---------- ----------   --- ----- ----  -----------"
DATA_END=" ------ inclusion threshold ------"
sed -n '/'"$DATA_BEGIN"'/, /'"$DATA_END"'/{ /'"$DATA_BEGIN"'/! { /'"$DATA_END"'/! p } }' $in | awk '{print $6"\t"$7"\t"$8"\t"$1"\t"$3"\t"$9}' | awk '{if($2 > $3) print $1"\t"$3"\t"$2"\t"$4"\t"$5"\t"$6; else print $0}' | bedtools sort -i - > $out
