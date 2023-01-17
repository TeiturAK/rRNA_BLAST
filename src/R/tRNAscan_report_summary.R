#' ---
#' title: "tRNAscan report summary"
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
})

#' # Description
#' Overview of the tRNAscan results


#' # Data
fasta.fai.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/fasta/pabies-2.0_chromosomes_and_unplaced.fa.fai"
fai.df <- read.delim(fasta.fai.path, header = FALSE)

tRNAscan.path <- "/mnt/picea/home/tkalman/tRNA-rRNA/tRNA_seq/tRNAscan_results/results.bed"
tRNAscan.df <- read.delim(tRNAscan.path, header = FALSE)

tRNAscan.df$tRNA.id <- gsub(".*-", "", tRNAscan.df$V4)
tRNAscan.df$tRNA.length <- tRNAscan.df$V3 - tRNAscan.df$V2

#' # Length distribution
#' Plotting length distribution
ggplot(tRNAscan.df, aes(x = tRNA.length, y = tRNA.id, color = tRNA.id)) +
  geom_density_ridges() +
  theme_minimal()

#' Removing observations longer than 100bp
tRNAscan.long_filtered.df <- tRNAscan.df[which(tRNAscan.df$tRNA.length <= 100), ]

#' Plotting length distribution after removal of suspiciously long tRNA
ggplot(tRNAscan.long_filtered.df, aes(x = tRNA.length, y = tRNA.id, color = tRNA.id)) +
  geom_density_ridges() +
  theme_minimal()

#' # Frequencies 
#' Looking at the tRNA id frequencies
DT::datatable(data.frame(table(tRNAscan.long_filtered.df$tRNA.id)))

#' There is something called "UndetNNN" with 179 obs. Removing these
tRNAscan.long_filtered.Undet_filtered.df <- tRNAscan.long_filtered.df[!tRNAscan.long_filtered.df$tRNA.id == "UndetNNN", ]

#' # Plotting tRNA obs. along chromosomes
plot_tRNA <- function(seq_to_look_at) {
  tmp.df <- tRNAscan.long_filtered.Undet_filtered.df[which(tRNAscan.long_filtered.Undet_filtered.df$V1 == seq_to_look_at), ]
  tmp.chr_upper_lim <- fai.df$V2[fai.df$V1 == seq_to_look_at]
  ggplot() +
    geom_point(tmp.df, mapping=aes(x = V2, y = tRNA.length, color = tRNA.id), position=position_jitter(h=3, w=3), alpha = 0.25, size = 1) +
    # geom_point(tmp.df[which(tmp.df$V6 == "+"), ], mapping=aes(x = V2, y = tRNA.length, color = tRNA.id), position=position_jitter(h=1, w=1), alpha = 0.25, size = 1) +
    # geom_point(tmp.df[which(tmp.df$V6 == "-"), ], mapping=aes(x = V2, y = -1*tRNA.length, color = tRNA.id), position=position_jitter(h=1, w=1), alpha = 0.25, size = 1) +
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
