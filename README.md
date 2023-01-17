# rRNA and tRNA annotation for new spruce genome assembly

## Brief overview of tools run for rRNA sequence and annotation
#### Consensus sequence generated from NCBI
NCBI Searchterm for rRNA sequences saved into Picea-Pinus_rRNA-subunits.fa:
("Pinus"[Organism] OR "Picea"[Organism]) AND (5S[All Fields] OR 5.8S[All Fields] OR 18S[All Fields] OR 25S[All Fields] OR 28S[All Fields]) AND rRNA[All Fields] NOT (mRNA[filter] OR cRNA[filter] OR ncRNA[filter] OR tRNA[filter]) NOT (chloroplast[filter] OR mitochondrion[filter] OR plastid[filter])

#### Merge NCBI sequences with cd-hit-est v4.8.1
cd-hit-est -i Picea-Pinus_rRNA-subunits.fa -o Picea_Pinus_rRNA_subunits.merge_id90.fa

#### Annotation with Barrnap v0.9
barrnap --threads 20 --kingdom euk --outseq rRNA.fa pabies-2.0_chromosomes_and_unplaced.fa > rRNA.gff

Full matches of 5S, 5.8S, 18S and 26S display array like distribution in genome at various places, more to be added about the report and possibly some more analysis.
28S is the name of the annotation in the gff because that is what barrnap outputs in its euk mode.
5.8S is found inside the 26S subunit, possible that ITS has been filtered out from assembly. Annotation consistently finds 18S–5.8S–26S transcribed in opposite order on the + strand. More notes will be added.

#### Merge barrnap sequences with cd-hit-est v4.8.1
cd-hit-est -i rRNA.fa -o rRNA.cd-hit-est.fa
