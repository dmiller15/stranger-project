source('variables.R')

load(res_outfile)

library(ggplot2)
library(DESeq2)
library(biomaRt)

results.df <- as.data.frame(deseq_results)
results.sig <- (abs(results.df$log2FoldChange) > 0.5 & results.df$padj<0.05)
ensembl <- useMart("ENSEMBL_MART_ENSEMBL",dataset="hsapiens_gene_ensembl", host="www.ensembl.org")
#gene_names <- rownames(results.df)


gene_names <- apply(matrix(rownames(results.df), ncol=1), 1, function(x) {unlist(strsplit(x, split='[.]'))[1]})
biomart.results=getBM(ensembl,
		      attributes=c("ensembl_gene_id","hgnc_symbol","entrezgene", "chromosome_name"),
		      filters="ensembl_gene_id",
		      values=gene_names)

pdf(file='volcano.pdf')
g <- ggplot(results.df, aes(x=log2FoldChange, y=-log10(pvalue), color=results.sig))
g + geom_point() + 
	scale_color_manual(values=c('TRUE'='red','FALSE'='black'), labels=c("Not Signif", "Signif"))
dev.off()
