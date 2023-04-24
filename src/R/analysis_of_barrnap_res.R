#' ---
#' title: "Analysis of barrnap output"
#' author: "Teitur Ahlgren Kalman"
#' date: "`r Sys.Date()`"
#' output:
#'  html_document:
#'    fig_width: 12 
#'    fig_height: 8 
#'    toc: true
#'    number_sections: false
#'    code_folding: "hide"
#' ---

#' # Libraries 
suppressPackageStartupMessages({
  library(systemPipeR)
  library(ggplot2)
  library(ggridges)
  library(DT)
  library(stringr)
  library(gridExtra)
  library(microseq)
})

#' # Description
#' Overview of the barrnap results.
#' 
#' De novo genome assembly of the medicinal plant Gentiana macrophylla provides insights into the genomic evolution and biosynthesis of iridoids:
#' "The tRNA genes were predicted using tRNAscan-SE,63 and the rRNA genes were identified by searching the genes in Rfam v 12.064 with barrnap v 0.9"
#' https://academic.oup.com/dnaresearch/article/29/6/dsac034/6748869

#' Important: The 26S subunit gets annotated as 28S by barrnap in its eukaryote mode.
 
#' Things I check for:

#'  That the subunits have the expected length. 
#'    5S: ∼120 nt
#'    5.8S: ~150nt
#'    18S: ~1700nt
#'    25/26S: ~3400-3700nt
#'    https://www.sciencedirect.com/science/article/abs/pii/0092867483904130?via%3Dihub
#'    https://www.thermofisher.com/se/en/home/references/ambion-tech-support/rna-isolation/general-articles/ribosomal-rna-sizes.html
#'    https://www.ncbi.nlm.nih.gov/nuccore/M11585.1

#'  The expectation is that there will be rRNA islands on the chromosomes. 
#'  5.8S, 18S and 26S will be transcribed together joined by a linker sequence like this 18S-5.8S-26S.
#'  "The 35S rDNA (called 45S rDNA in animals) typically contains three tightly linked rRNA genes (18S–5.8S–26S). These genes are separated by internal 
#'  transcribed spacers (ITS1 and ITS2)"
#'  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6526317/
#'  
#'  ITS1 is located between 18S and 5.8S rRNA genes, while ITS2 is between 5.8S and 28S (in opisthokonts, or 25S in plants) rRNA genes. 
#'  (https://en.wikipedia.org/wiki/Internal_transcribed_spacer)
#'  
#'  For 5S I expect that there will be stretches of 5S in tandem and these to have variable non-transcribed spacers: 
#'  
#'  "The fourth gene is called 5S rRNA, and it usually forms separate arrays at chromosomal loci that are independent of the 35S rDNA in plant genomes."
#'  ...
#'  "This is called the S-type arrangement of rDNA and, when organized in this way, the individual 5S rRNA genes are separated by a non-transcribed 
#'  spacers (NTS) of variable length (Hemleben and Grierson, 1978; Ellis et al., 1988; Campell et al., 1992; Gorman et al., 1992; Wicke et al., 2011)."
#'  ...
#'  "Overall, the data indicate that these gymnosperm lineages have an S-type arrangement of rDNA"
#'  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6526317/

#'  "The 5S ribosomal DNA in higher eukaryotes is generally organized in tandem arrays, 
#'  the repeated unit of which contains the transcription unit and a spacer sequence. 
#'  These tandem arrays may be localized on either a single or several chromosomes and 
#'  are separated from the genes encoding the large rRNAs (Appels et al. 1980; Long and Dawid 1980; Ellis et al. 1988)."
#'  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC310874/

#' # Data
fasta.fai.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa.fai"
fai.df <- read.delim(fasta.fai.path, header = FALSE)

barrnap.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/rRNA_seq/barrnap_res/rRNA.gff"
barrnap.df <- read.delim(barrnap.path, header = FALSE, skip = 1)

#' Extract subunit ID
barrnap.df$subunit <- gsub('^.*product=\\s*|\\s* .*$', '', barrnap.df$V9)

#' Add annotation lengths 
barrnap.df$subunit.length <- barrnap.df$V5 - barrnap.df$V4

#' Add if annotation is a partial match
barrnap.df$partial <- str_detect(barrnap.df$V9, "(partial)")
barrnap.df$subunit.partial_info <- barrnap.df$subunit

barrnap.df$subunit.partial_info[which(barrnap.df$partial == TRUE)] <-  paste(barrnap.df$subunit.partial_info[which(barrnap.df$partial == TRUE)], "partial", sep = ".")

#' # Length distribution
#' Plotting length distribution of all subunits, partial and full
plot_subunuit_length <- function (subunit) {
  ggplot(barrnap.df[barrnap.df$subunit == subunit, ], aes(x = subunit.length, y = partial, color = partial)) +
    geom_density_ridges() +
    ggtitle(subunit) +
    theme_minimal()
}

#' 5S length distr.
plot_subunuit_length(subunit = "5S")

#' There is a subset of "full" 5S subunit annotations that are about the same length as the partial annotations below 100nt, I'm giving these their own "short" label
barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "5S" & barrnap.df$subunit.length < 100)] <-  paste(barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "5S" & barrnap.df$subunit.length < 100)], "short", sep = ".")

#' 5.8S length distr.
plot_subunuit_length(subunit = "5.8S")

#' 18S length distr.
plot_subunuit_length(subunit = "18S")

#' The full 18S subunit annotations have some observations shorter observations, assigning "short" to those below 1625nt 
barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "18S" & barrnap.df$subunit.length < 1625)] <-  paste(barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "18S" & barrnap.df$subunit.length < 1625)], "short", sep = ".")

#' 26S length distr.
plot_subunuit_length(subunit = "28S")

#' The full 26S subunit annotations has a long tail of shorter observations, assigning "short" to those below 3600nt 
barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "28S" & barrnap.df$subunit.length < 3600)] <-  paste(barrnap.df$subunit.partial_info[which(barrnap.df$subunit.partial_info == "28S" & barrnap.df$subunit.length < 3600)], "short", sep = ".")

#' Interpretation of partial and full sequence match, it is important to note that barrnap does a scan and that the length 
#' of partial matches reflects the length of the match to the reference.

#' # Frequencies, including short and partial annotations 
#' Total count of each type of annotation
DT::datatable(data.frame(table(barrnap.df$subunit.partial_info)))

#' How do the annotations distribute over contigs?
contigs <- c(fai.df$V1)

subunit_annotations <- sort(unique(barrnap.df$subunit.partial_info))

subunits_obs_by_contig.df <- do.call(rbind, lapply(contigs, function (tmp.contig) {
  tmp.df <- barrnap.df[which(barrnap.df$V1 == tmp.contig), ]
  
  tmp.table <- data.frame(table(tmp.df$subunit.partial_info))
  
  # Creating a dummy out table with all possible observations on the current chr
  tmp.dummy.df <- data.frame("subunit" = subunit_annotations,
                             "count" = 0)
  
  # Changing the count for the subunits that had observations on the current chr
  tmp.dummy.df$count[which(tmp.dummy.df$subunit %in% tmp.table$Var1)] <- tmp.table$Freq
  
  tmp.out.df <- data.frame(t(tmp.dummy.df$count))
  colnames(tmp.out.df) <- tmp.dummy.df$subunit
  rownames(tmp.out.df) <- tmp.contig
  tmp.out.df
}))

DT::datatable(subunits_obs_by_contig.df)

#' How do the annotations distribute over the chromosomes?
chromosomes <- c(fai.df$V1[1:12])

subunits_obs_by_chr.df <- do.call(rbind, lapply(chromosomes, function (tmp.chr) {
  tmp.df <- barrnap.df[which(barrnap.df$V1 == tmp.chr), ]
  
  tmp.table <- data.frame(table(tmp.df$subunit.partial_info))
  
  # Creating a dummy out table with all possible observations on the current chr
  tmp.dummy.df <- data.frame("subunit" = subunit_annotations,
                             "count" = 0)
  
  # Changing the count for the subunits that had observations on the current chr
  tmp.dummy.df$count[which(tmp.dummy.df$subunit %in% tmp.table$Var1)] <- tmp.table$Freq
  
  tmp.out.df <- data.frame(t(tmp.dummy.df$count))
  colnames(tmp.out.df) <- tmp.dummy.df$subunit
  rownames(tmp.out.df) <- tmp.chr
  tmp.out.df
}))

DT::datatable(subunits_obs_by_chr.df)

#' # Plotting subunit obs. along chromosomes
plot_rRNA <- function(seq_to_look_at) {
  
  tmp.df <- barrnap.df[which(barrnap.df$V1 == seq_to_look_at), ]
  tmp.chr_upper_lim <- fai.df$V2[fai.df$V1 == seq_to_look_at]
  tmp.p1 <- ggplot() +
    geom_point(tmp.df[which(tmp.df$V7 == "+"), ], mapping=aes(x = V4, y = subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    geom_point(tmp.df[which(tmp.df$V7 == "-"), ], mapping=aes(x = V4, y = -1*subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    scale_x_continuous(limits = c(0, tmp.chr_upper_lim)) +
    xlab("coord") +
    ggtitle(seq_to_look_at) +
    theme_minimal()
  
  no_short_or_partial_annotations <- c("5S", "5.8S", "18S", "28S")
  tmp.only_full_matches.df <- tmp.df[which(tmp.df$subunit.partial_info %in% no_short_or_partial_annotations), ]
  
  tmp.p2 <- ggplot() +
    geom_point(tmp.only_full_matches.df[which(tmp.only_full_matches.df$V7 == "+"), ], mapping=aes(x = V4, y = subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    geom_point(tmp.only_full_matches.df[which(tmp.only_full_matches.df$V7 == "-"), ], mapping=aes(x = V4, y = -1*subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    scale_x_continuous(limits = c(0, tmp.chr_upper_lim)) +
    xlab("coord") +
    ggtitle(seq_to_look_at) +
    theme_minimal()
  
  grid.arrange(tmp.p1, tmp.p2, ncol=2)
  
}

plot_rRNA(seq_to_look_at = "PA_chr01")  

plot_rRNA(seq_to_look_at = "PA_chr02")

plot_rRNA(seq_to_look_at = "PA_chr03")

plot_rRNA(seq_to_look_at = "PA_chr04")

plot_rRNA(seq_to_look_at = "PA_chr05")

plot_rRNA(seq_to_look_at = "PA_chr06")

plot_rRNA(seq_to_look_at = "PA_chr07")

plot_rRNA(seq_to_look_at = "PA_chr08")

plot_rRNA(seq_to_look_at = "PA_chr09")

plot_rRNA(seq_to_look_at = "PA_chr10")

plot_rRNA(seq_to_look_at = "PA_chr11")

plot_rRNA(seq_to_look_at = "PA_chr12")

#' Also looking at some of the contigs that I saw had high numbers of the large subunits 
#' with similar numbers between 5.8S, 18S and 28S. 
plot_rRNA(seq_to_look_at = "PA_sUP003")

plot_rRNA(seq_to_look_at = "PA_cUP0124")

plot_rRNA(seq_to_look_at = "PA_sUP012")

plot_rRNA(seq_to_look_at = "PA_cUP0131")

plot_rRNA(seq_to_look_at = "PA_sUP014")

#' The contigs give a nice view of how the stretches of 5.8S, 18S and 26S are overlapping on the same strand.
#' PA_sUP014 which is the smallest contig show the expected 18S-5.8S-26S https://pubmed.ncbi.nlm.nih.gov/15032949/.

#' # Looking for evidence that the "full" matches of large subunits are transcribed together in the right order.
#' Does not work well to look at here but works well in genome browser. 
# tmp.df <- barrnap.df[which(barrnap.df$V1 == "PA_sUP012"), ]
# tmp.only_full_matches.df <- tmp.df[which(tmp.df$subunit.partial_info %in% no_short_or_partial_annotations), ]

#' # Write full matches to file
# no_short_or_partial_annotations <- c("5S", "5.8S", "18S", "28S")
# barrnap.only_full_matches.df <- barrnap.df[which(barrnap.df$subunit.partial_info %in% no_short_or_partial_annotations), ]
# 
# barrnap.only_full_matches.df <- barrnap.only_full_matches.df[, c(1:9)]
# 
barrnap.only_full_matches.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/rRNA_seq/barrnap_res/rRNA.full_matches.gff"
# writeGFF(barrnap.only_full_matches.df, out.file = barrnap.only_full_matches)

#' # How much of genome is covered by rDNA?
moduleload("bioinfo-tools BEDTools")

contig_length.sum <- sum(fai.df$V2)

#' % of genome covered by all annotated rDNA regions
rDNA_length.sum <- as.numeric(system(paste("bedtools sort -i", barrnap.path,
                                           "| bedtools merge -i - | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'"),
                                     intern = TRUE))

print ((rDNA_length.sum/contig_length.sum) * 100)


#' % of genome covered by full match annotated rDNA regions
rDNA_fullmatch_length.sum <- as.numeric(system(paste("bedtools sort -i", barrnap.only_full_matches.path,
                                                     "| bedtools merge -i - | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'"),
                                               intern = TRUE))

print ((rDNA_fullmatch_length.sum/contig_length.sum) * 100)

