if (!require(DESeq2)) {
        library(BiocInstaller)
        biocLite('DESeq2')
        library(DESeq2)
}

library(ggplot2)
library(sva)
library(biomaRt)

library(BiocParallel)
register(MulticoreParam(4))

source('variables.R')

load(paste(cancer_type,'count.Robj', sep="_"))
load(paste(cancer_type,'phen.Robj', sep="_"))

performDE <- function(expr, phen) {

        # First, filter genes with 0 count in all individuals
        use <- (rowSums(expr) > 0)
        expr <- expr[use,]

        # Filter low gene counts
        # Genes must have counts > 10 in at least 6 males or 6 females

	nmale <- sum(phen$gender == 'male')
	maleUse <- (rowSums(expr[, phen$gender=='male'] > 10) >= 6 )
	nfemale <- sum(phen$gender == 'female')
	femaleUse <- (rowSums(expr[, phen$gender=='female'] > 10) >= 6 )

	expr <- expr[(maleUse | femaleUse),]
	print(dim(expr))

	dds <- DESeqDataSetFromMatrix(countData = expr, colData = phen, design = ~ gender)
	dds <- estimateSizeFactors(dds)
	dat <- counts(dds, normalized=TRUE)

	mod <- model.matrix(~phen$gender, colData(dds))
	mod0 <- model.matrix(~1, colData(dds))
	svseq <- svaseq(dat, mod, mod0, n.sv=2)

	ddssva <- dds
	rm(dds)
	ddssva$SV1 <- svseq$sv[,1]
	ddssva$SV2 <- svseq$sv[,2]
	design(ddssva) <- ~ SV1 + SV2 + gender  
	ddssva <- DESeq(ddssva, parallel=T)
	
	return(ddssva)
                                                                                        
}

expr_df <- counts_df
rm(counts_df)

exp_stats <- expr_df[(nrow(expr_df)-4):nrow(expr_df),]
exprs <- expr_df[1:(nrow(expr_df)-5),]

deseq <- performDE(exprs, phens)
#save(deseq, file=de_outfile)

deseq_results <- results(deseq, parallel=T)
deseq_results <- deseq_results[order(deseq_results$padj),]

ensembl <- useMart("ENSEMBL_MART_ENSEMBL",dataset="hsapiens_gene_ensembl", host="www.ensembl.org")
#gene_names <- rownames(results.df)

results.df <- as.data.frame(deseq_results)
gene_names <- apply(matrix(rownames(results.df), ncol=1), 1, function(x) {unlist(strsplit(x, split='[.]'))[1]})
biomart.results=getBM(ensembl,
		      attributes=c("ensembl_gene_id","hgnc_symbol","entrezgene", "chromosome_name"),
		      filters="ensembl_gene_id",
		      values=gene_names)


results.df$Ensembl <- gene_names
#results.df$symbol <- biomart.results$hgnc_symbol
write.csv(results.df, file=paste(cancer_type,'results.csv', sep='.'))
save(deseq_results, file=res_outfile)
