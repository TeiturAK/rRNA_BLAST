#' ---
#' title: "analysis of tRNAscan output"
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
  library(microseq)
})

#' # Description
#' Overview of the tRNAscan-SE 2 results.
#' 
#' tRNAscan-SE 2 was used for creating the results in this plant tRNA web resource:
#' https://bioinformatics.um6p.ma/PltRNAdb/index.php (https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0268904)
#' 
#' I check the size of the the annotations. The expected length of the tRNAs are expected to be ~70-90bp and except for ~40 obs. in our results the length is within that window.
#' (https://www.sciencedirect.com/topics/agricultural-and-biological-sciences/transfer-rna) 
#' 
#' I look at how many tRNAs are classed as pseudogenes as the output contains tRNA genes predicted to be biologically active and tRNA derived SINEs marked as pseduogenes: 
#' "As part of the functional classification, tRNAscan-SE evaluates the gene predictions for possible pseudogenes based on characteristics commonly observed in non-functional 
#' tRNAs: a relatively weak overall score (<55 bits) and either a very low primary sequence score (<10 bits), or very low secondary structure score (<5 bits)."
#' https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6768409/#:~:text=As%20part%20of,score%20(%3C5%20bits). 
#' 1295 annotations are marked as pseudogene and 8220 as biologically functional.
#' 
#' I make sure all 20 standard isoacceptors are represented in the high confidence set of tRNAs predicted. 
#' 
#' The count of tRNA in the output (~8000) is huge in comparison to many other species but the PltRNAdb has examples of species with tRNA annotations in the thousands: 
#' https://journals.plos.org/plosone/article/figure?id=10.1371/journal.pone.0268904.t004
#' This article "A global picture of tRNA genes in plant genomes" (https://pubmed.ncbi.nlm.nih.gov/21443625/) looked at genome size and tRNA genes and saw a linear 
#' correlation between genome size and tRNA genes in six plant genomes with the exception of one species. All species were smaller than 1Gbp. There was no correlation
#' between genome size and pseudogenes. In a publication for Chinese fir, "Chinese fir genome and the evolution of gymnosperms" they explicitly state that they found 
#' ~4000 tRNA genes in the ~12GB genome (https://www.biorxiv.org/content/biorxiv/early/2022/10/26/2022.10.25.513437.full.pdf). 
#' 
#' It has been described in rice that the the different tRNA gene iso-acceptors are unevenly distributed over the chromosomes, we also observe that in spruce.
#' (https://www.frontiersin.org/articles/10.3389/fgene.2017.00090/full#:~:text=tRNAs%20Are%20Distributed%20Unevenly%20in%20Different%20Chromosomes).

#' # Data
fasta.fai.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa.fai"
fai.df <- read.delim(fasta.fai.path, header = FALSE)

tRNAscan.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/tRNA_seq/tRNAscan-SE_Infernal-mode/tRNA.gff"
tRNAscan.df <- read.delim(tRNAscan.path, header = FALSE, skip = 1, comment.char = "#")

#' # How many tRNA genes, how many of which marked as pseudogenes?
tRNAscan.sub.df <- tRNAscan.df[(tRNAscan.df$V3 != "exon"), ]

table(tRNAscan.sub.df$V3)

#' Filtering out tRNA genes marked as pseudogenes.
tRNAscan.sub.df <- tRNAscan.sub.df[(tRNAscan.sub.df$V3 != "pseudogene"), ]

#' Naming the predictions by isotype and anticodon
tRNAscan.sub.df$isotype <- gsub(".*isotype=\\s*|;.*", "", tRNAscan.sub.df$V9)
tRNAscan.sub.df$anticodon <- gsub(".*anticodon=\\s*|;.*", "", tRNAscan.sub.df$V9)

tRNAscan.sub.df$isotype.anticodon <- paste0(tRNAscan.sub.df$isotype, tRNAscan.sub.df$anticodon)

#' # Length distribution
tRNAscan.sub.df$gene.length <- tRNAscan.sub.df$V5 - tRNAscan.sub.df$V4

ggplot(tRNAscan.sub.df, aes(x = gene.length, y = isotype.anticodon, color = isotype.anticodon)) +
  geom_density_ridges() +
  theme_minimal()

# A few observations are not part of the density that the rest of the genes show, how many are these?
print (length(which(tRNAscan.sub.df$gene.length > 100)))

#' Removing observations longer than 100bp
tRNAscan.sub.df <- tRNAscan.sub.df[which(tRNAscan.sub.df$gene.length <= 100), ]

ggplot(tRNAscan.sub.df, aes(x = gene.length, y = isotype.anticodon, color = isotype.anticodon)) +
  geom_density_ridges() +
  theme_minimal()

#' # How many of each type of tRNA is found, both the three letter anticodon and the isotype.  
DT::datatable(data.frame(table(tRNAscan.sub.df$isotype)))

DT::datatable(data.frame(table(tRNAscan.sub.df$isotype.anticodon)))

#' # Frequencies of each type on the chromosomes?
#' How do the isotype annotations distribute over contigs?
contigs <- c(fai.df$V1)

isotype_annotations <- sort(unique(tRNAscan.sub.df$isotype))

isotype_obs_by_contig.df <- do.call(rbind, lapply(contigs, function (tmp.contig) {
  tmp.df <- tRNAscan.sub.df[which(tRNAscan.sub.df$V1 == tmp.contig), ]
  
  tmp.table <- data.frame(table(tmp.df$isotype))
  
  # Creating a dummy out table with all possible observations on the current chr
  tmp.dummy.df <- data.frame("isotype" = isotype_annotations,
                             "count" = 0)
  
  # Changing the count for the subunits that had observations on the current chr
  tmp.dummy.df$count[which(tmp.dummy.df$isotype %in% tmp.table$Var1)] <- tmp.table$Freq
  
  tmp.out.df <- data.frame(t(tmp.dummy.df$count))
  colnames(tmp.out.df) <- tmp.dummy.df$isotype
  rownames(tmp.out.df) <- tmp.contig
  tmp.out.df
}))

DT::datatable(isotype_obs_by_contig.df)

#' # Plotting tRNA obs. along chromosomes
#' (There are barely any annotations found on the unplaced)
plot_tRNA <- function(seq_to_look_at) {
  tmp.df <- tRNAscan.sub.df[which(tRNAscan.sub.df$V1 == seq_to_look_at), ]
  tmp.chr_upper_lim <- fai.df$V2[fai.df$V1 == seq_to_look_at]
  ggplot() +
    geom_point(tmp.df, mapping=aes(x = V4, y = gene.length, color = isotype.anticodon), position=position_jitter(h=3, w=3), alpha = 0.25, size = 1) +
    scale_x_continuous(limits = c(0, tmp.chr_upper_lim)) +
    xlab("coord") +
    ggtitle(seq_to_look_at) +
    coord_polar() +
    theme_minimal()
}

plot_tRNA(seq_to_look_at = "PA_chr01")  

plot_tRNA(seq_to_look_at = "PA_chr02")

plot_tRNA(seq_to_look_at = "PA_chr03")

plot_tRNA(seq_to_look_at = "PA_chr04")

plot_tRNA(seq_to_look_at = "PA_chr05")

plot_tRNA(seq_to_look_at = "PA_chr06")

plot_tRNA(seq_to_look_at = "PA_chr07")

plot_tRNA(seq_to_look_at = "PA_chr08")

plot_tRNA(seq_to_look_at = "PA_chr09")

plot_tRNA(seq_to_look_at = "PA_chr10")

plot_tRNA(seq_to_look_at = "PA_chr11")

plot_tRNA(seq_to_look_at = "PA_chr12")

#' Possible additions below
#' # How much of the tRNA is found in clusters?
#' moduleload("bioinfo-tools BEDTools")
#' 
#' tRNA.only_bio_active.no_long.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/tRNA_seq/tRNAscan-SE_Infernal-mode/tRNA.only_bio_active.no_long.gff"
#' # writeGFF(tRNAscan.sub.df[, c(1:9)], out.file = tRNA.only_bio_active.no_long.path)
#' 
#' test.df <- data.frame(do.call(rbind, strsplit(system(paste("bedtools sort -i", tRNA.only_bio_active.no_long.path, "| bedtools cluster -i - -d 1000"), intern = TRUE), "\t")))
#' 
#' test2.df <- data.frame(table(test.df$X10))
#' 
#' sum(test2.df$Freq[which(test2.df$Freq > 5)])
#' 
#' 
#' ggplot(test2.df, aes(x = Freq)) + geom_density()
#' 
#' #' # What is the cluster composition?
