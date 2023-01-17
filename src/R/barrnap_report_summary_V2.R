#' ---
#' title: "barrnap report summary"
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
  # library(systemPipeR)
  library(ggplot2)
  library(ggridges)
  library(DT)
  library(stringr)
  library(gridExtra)
})

#' # Description
#' Overview of the barrnap results
#' Important: The 26S subunit gets annotated as 28S by barrnap

#' # Data
fasta.fai.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa.fai"
fai.df <- read.delim(fasta.fai.path, header = FALSE)

barrnap.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/rRNA_seq/barrnap_res/rrna.only-gff-lines-manually-extracted-with-head.gff"
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

#' # Frequencies, including short and partial annotations 
#' Total count of each type of annotation
DT::datatable(data.frame(table(barrnap.df$subunit.partial_info)))

#' How do the annotations distribute over the chromosomes?
chromosomes <- c(fai.df$V1[1:12])

subunit_annotations <- sort(unique(barrnap.df$subunit.partial_info))

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

#' # Plotting subunit obs. along chromosomes, including short and partial annotations
plot_rRNA <- function(seq_to_look_at) {
  tmp.df <- barrnap.df[which(barrnap.df$V1 == seq_to_look_at), ]
  tmp.chr_upper_lim <- fai.df$V2[fai.df$V1 == seq_to_look_at]
  ggplot() +
    geom_point(tmp.df[which(tmp.df$V7 == "+"), ], mapping=aes(x = V4, y = subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    geom_point(tmp.df[which(tmp.df$V7 == "-"), ], mapping=aes(x = V4, y = -1*subunit.length, color = subunit.partial_info), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    scale_x_continuous(limits = c(0, tmp.chr_upper_lim)) +
    xlab("coord") +
    ggtitle(seq_to_look_at) +
    theme_minimal()
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

#' # Plotting subunit obs. along chromosomes, excluding short and partial
no_short_or_partial_annotations <- c("5S", "5.8S", "18S", "28S")

barrnap.no_short_or_partial.df <- barrnap.df[which(barrnap.df$subunit.partial_info %in% no_short_or_partial_annotations), ]

plot_rRNA <- function(seq_to_look_at) {
  tmp.df <- barrnap.no_short_or_partial.df[which(barrnap.no_short_or_partial.df$V1 == seq_to_look_at), ]
  tmp.chr_upper_lim <- fai.df$V2[fai.df$V1 == seq_to_look_at]
  ggplot() +
    geom_point(tmp.df[which(tmp.df$V7 == "+"), ], mapping=aes(x = V4, y = subunit.length, color = subunit), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    geom_point(tmp.df[which(tmp.df$V7 == "-"), ], mapping=aes(x = V4, y = -1*subunit.length, color = subunit), position=position_jitter(h=3, w=3), alpha = 0.25, size = 2) +
    scale_x_continuous(limits = c(0, tmp.chr_upper_lim)) +
    xlab("coord") +
    ggtitle(seq_to_look_at) +
    theme_minimal()
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

