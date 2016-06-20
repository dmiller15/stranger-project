source('variables.R')

load(res_outfile)

library(ggplot2)
library(DESeq2)
#library(biomaRt)
results.df <- as.data.frame(deseq_results)

pdf(file='volcano.pdf')
g <- ggplot(results.df, aes(x=log2FoldChange, y=-log10(pvalue)))
g + geom_point()
dev.off()

#ensembl = useMart("ENSEMBL_MART_ENSEMBL",dataset="hsapiens_gene_ensembl", host="www.ensembl.org")
