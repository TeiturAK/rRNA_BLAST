# rRNA and tRNA annotation for new spruce genome assembly

## Brief overview of tools run for rRNA sequence and annotation
### Consensus sequence generated from NCBI
NCBI Searchterm for rRNA sequences saved into Picea-Pinus_rRNA-subunits.fa:
("Pinus"[Organism] OR "Picea"[Organism]) AND (5S[All Fields] OR 5.8S[All Fields] OR 18S[All Fields] OR 25S[All Fields] OR 28S[All Fields]) AND rRNA[All Fields] NOT (mRNA[filter] OR cRNA[filter] OR ncRNA[filter] OR tRNA[filter]) NOT (chloroplast[filter] OR mitochondrion[filter] OR plastid[filter])

#### Merge NCBI sequences with cd-hit-est v4.8.1
cd-hit-est -i Picea-Pinus_rRNA-subunits.fa -o Picea_Pinus_rRNA_subunits.merge_id90.fa

### Annotation with Barrnap v0.9
barrnap --threads 20 --kingdom euk --outseq rRNA.fa pabies-2.0_chromosomes_and_unplaced.fa > rRNA.gff

Full matches of 5S and 35S (5.8S, 18S and 26S) display array like distribution in genome. 28S is the name of the annotation in the gff because that is what barrnap outputs in its euk mode. 5.8S is found inside the 26S subunit. Probably because the HMM model is for 28S and interprets the ITS between these two subunits as part of the 28S subunit.

#### Merge barrnap sequences with cd-hit-est v4.8.1
cd-hit-est -i rRNA.fa -o rRNA.cd-hit-est.fa

### Annotation with tRNAscan-SE v2.0.9
#### (Search is done with Infernal in eukaryote mode)
tRNAscan-SE -E -I --log log --gff tRNA.gff --bed tRNA.bed --missed missed --hitsrc --progress --thread 20 -o results pabies-2.0_chromosomes_and_unplaced.fa
