# rRNA and tRNA annotation for new spruce genome assembly

## Brief overview of tools run for rRNA sequence and annotation
#### Consensus sequence generated from NCBI
NCBI Searchterm for rRNA sequences saved into Picea-Pinus_rRNA-subunits.fa:
("Pinus"[Organism] OR "Picea"[Organism]) AND (5S[All Fields] OR 5.8S[All Fields] OR 18S[All Fields] OR 25S[All Fields] OR 28S[All Fields]) AND rRNA[All Fields] NOT (mRNA[filter] OR cRNA[filter] OR ncRNA[filter] OR tRNA[filter]) NOT (chloroplast[filter] OR mitochondrion[filter] OR plastid[filter])

#### Merge NCBI sequences with cd-hit-est v4.8.1
cd-hit-est -i Picea-Pinus_rRNA-subunits.fa -o Picea_Pinus_rRNA_subunits.merge_id90.fa

#### Annotation with Barrnap v0.9
barrnap --threads 20 --kingdom euk --outseq rRNA.fa pabies-2.0_chromosomes_and_unplaced.fa > rRNA.gff

#### Merge barrnap sequences with cd-hit-est v4.8.1
cd-hit-est -i rRNA.fa -o rRNA.cd-hit-est.fa
