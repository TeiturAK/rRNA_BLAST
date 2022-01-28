#' ---
#' title: "RepeatMasker rRNA report summary"
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
#' of the rDNA sequences found with RepeatMasker.
#' 
#' 

#' ```{r set up, echo=FALSE}
#' knitr::opts_knit$set(root.dir="/mnt/picea/home/tkalman")
#' ```

#' # How much of the chromosomes have with regions with found rDNA?
#' All rDNA annotations are merged and non-redundant so no two regions overlap.
rDNA.total_count <- system(paste("cat /mnt/picea/home/tkalman/rRNA_facility/RepeatMasker_only-chromosomes_4-Nov-2021/*/*.fasta.merged.bed | awk '{print $3-$2}' | awk '{s+=$1} END {print s}'"),
                           intern = TRUE)
print (rDNA.total_count)

#' # Functions for plotting
#' Looking at the intersects chunk by chunk to keep memory down
every_nth = function(n) {
  return(function(x) {x[c(TRUE, rep(FALSE, n - 1))]})
}

plot.sliding_window_intersect <- function(RM.path, contig.ID) {
  tmp.df <- data.frame(do.call(rbind, strsplit(system(paste("grep -w", contig.ID, RM.path), intern = TRUE), "\t")))
  
  ggplot(tmp.df, aes(x = as.numeric(X3), y = as.numeric(X4), group = 1)) +
    geom_point() +
    ggtitle(paste("rRNA feature overlap per 10kb window in:", contig.ID)) +
    ylab("length of overlap (bp)") +
    xlab("chromosome coordinate (bp)") +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1))
  
 }

#' # Analysis of rDNA in chromosomes
#' rDNA annotations have been intersected with non-overlapping 10kb windows
plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_001.fasta.merged.collapsed.bed", 
                              "PA_chr01")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_001.fasta.merged.collapsed.bed", 
                              "PA_chr02")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_002.fasta.merged.collapsed.bed", 
                              "PA_chr03")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_002.fasta.merged.collapsed.bed", 
                              "PA_chr04")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_003.fasta.merged.collapsed.bed", 
                              "PA_chr05")


plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_003.fasta.merged.collapsed.bed", 
                              "PA_chr06")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_004.fasta.merged.collapsed.bed", 
                              "PA_chr07")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_004.fasta.merged.collapsed.bed", 
                              "PA_chr08")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_005.fasta.merged.collapsed.bed", 
                              "PA_chr09")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_005.fasta.merged.collapsed.bed", 
                              "PA_chr10")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_006.fasta.merged.collapsed.bed", 
                              "PA_chr11")

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/Pabies.10000bp-windows-pabies-2.0_chromosomes.part_006.fasta.merged.collapsed.bed", 
                              "PA_chr12")

#' # Analysis of rDNA in unplaced
#' There are 882 contigs of unplaced sequences, looking at all of them at the same time
#' since these are of uneven length I normalize with contiglengths
plot.sliding_window_intersect <- function(RM.path) {
  tmp.df <- data.frame(do.call(rbind, strsplit(system(paste("cat", RM.path), intern = TRUE), "\t")))
  
  ggplot(tmp.df, aes(x = X1, y = as.numeric(X4)/as.numeric(X3)*100, group = 1)) +
    geom_point() +
    scale_x_discrete(breaks = every_nth(n = 50)) +
    ggtitle(paste("rRNA feature overlap in unplaced")) +
    ylab("length of overlap (% of total contig length)") +
    xlab("chromosome coordinate (bp)") +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 7, angle = 90, hjust = 1))
}

plot.sliding_window_intersect("/mnt/picea/home/tkalman/rRNA/sliding-window/P.abies/intersect/unplaced_contiglengths-pabies-2.0_unplaced.fasta.merged.collapsed.bed")

