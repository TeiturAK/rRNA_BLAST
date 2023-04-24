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
#### (Search is done with Infernal in eukaryote mode by default)
tRNAscan-SE --log log --gff tRNA.gff --bed tRNA.bed --fasta tRNA.fa --missed missed --hitsrc --progress --thread 20 -o results pabies-2.0_chromosomes_and_unplaced.fa

The count of tRNA in the output (~8000) is huge in comparison to many other species but the PltRNAdb has examples of species with tRNA annotations in the thousands (Brassica napus, Chara Braunii, Hordeum vulgare, Triticum aestivum and Zea Mays): 
https://journals.plos.org/plosone/article/figure?id=10.1371/journal.pone.0268904.t004.
In a publication for Chinese fir, "Chinese fir genome and the evolution of gymnosperms" they state that they found ~4000 tRNA genes in the ~12GB genome (https://www.biorxiv.org/content/biorxiv/early/2022/10/26/2022.10.25.513437.full.pdf).
