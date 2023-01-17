#' ---
#' title: "Barrnap rRNA report summary"
#' author: "Teitur Ahlgren Kalman"
#' date: "`r Sys.Date()`"
#' output:
#'  html_document:
#'    toc: true
#'    number_sections: false
#'    code_folding: "hide"
#' ---

#' # Libraries 
suppressPackageStartupMessages({
  library(systemPipeR)
  library(ggplot2)
})

#' # Description
#' Looking at the where rDNA sequences are found in the new P.abies assembly.
#' To produce this report I intersected 10kb windows of the genome with locations 
#' of the rDNA sequences found with Barrnap.

#' # Data
barrnap.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/rRNA_seq/barrnap_res/rrna.only-gff-lines-manually-extracted-with-head.gff"

#' # How much of the chromosomes have with regions with found rDNA?
#' All rDNA annotations are merged and non-redundant so no two regions overlap.
rDNA.total_count <- system(paste("cat", barrnap.path, "| awk '{print $5-$4}' | awk '{s+=$1} END {print s}'"),
                           intern = TRUE)
print (rDNA.total_count)


#' # Plotting 
rrna_on_contig.plot <- function(contig) {
  tmp.df <- data.frame(do.call(rbind, strsplit(system(paste("grep -w", contig, barrnap.path), intern = TRUE), "\t")))
  tmp.df$subunit <- gsub('^.*product=\\s*|\\s* .*$', '', tmp.df$X9)
  
  tmp.df$overlap <- as.numeric(tmp.df$X5) - as.numeric(tmp.df$X4)
  
  ggplot() +
    geom_point(tmp.df[which(tmp.df$X7 == "+"), ], mapping=aes(x = as.numeric(X4), y = overlap, color = subunit), position=position_jitter(h=0.3, w=0.3), alpha = 0.5, size = 1) +
    geom_point(tmp.df[which(tmp.df$X7 == "-"), ], mapping=aes(x = as.numeric(X4), y = -1*overlap, color = subunit), position=position_jitter(h=0.3, w=0.3), alpha = 0.5, size = 1) +
    xlab("coord") +
    ggtitle(paste(contig)) +
    theme_minimal()
}


rrna_on_contig.plot(contig = "PA_chr01")
rrna_on_contig.plot(contig = "PA_chr02")
rrna_on_contig.plot(contig = "PA_chr03")
rrna_on_contig.plot(contig = "PA_chr04")
rrna_on_contig.plot(contig = "PA_chr05")
rrna_on_contig.plot(contig = "PA_chr06")
rrna_on_contig.plot(contig = "PA_chr07")
rrna_on_contig.plot(contig = "PA_chr08")
rrna_on_contig.plot(contig = "PA_chr09")
rrna_on_contig.plot(contig = "PA_chr10")
rrna_on_contig.plot(contig = "PA_chr11")
rrna_on_contig.plot(contig = "PA_chr12")


tmp.df <- data.frame(do.call(rbind, strsplit(system(paste("grep -w", "PA_chr10", barrnap.path), intern = TRUE), "\t")))
tmp.df$subunit <- gsub('^.*product=\\s*|\\s* .*$', '', tmp.df$X9)

tmp.df$overlap <- as.numeric(tmp.df$X5) - as.numeric(tmp.df$X4)

ggplot() +
  geom_point(tmp.df[which(tmp.df$X7 == "+"), ], mapping=aes(x = as.numeric(X4), y = overlap, color = subunit), position=position_jitter(h=0.3, w=0.3), alpha = 0.5, size = 1) +
  geom_point(tmp.df[which(tmp.df$X7 == "-"), ], mapping=aes(x = as.numeric(X4), y = -1*overlap, color = subunit), position=position_jitter(h=0.3, w=0.3), alpha = 0.5, size = 1) +
  xlab("coord") +
  ggtitle(paste("PA_chr05")) +
  theme_minimal()
