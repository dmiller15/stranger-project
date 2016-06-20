source('variables.R')

load(res_outfile)

library(ggplot2)
library(biomaRt)
results.df <- data.frame(deseq_results)

ensembl = useMart("ENSEMBL_MART_ENSEMBL",dataset="hsapiens_gene_ensembl", host="www.ensembl.org")
