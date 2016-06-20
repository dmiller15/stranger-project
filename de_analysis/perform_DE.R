if (!require(DESeq2)) {
        library(BiocInstaller)
        biocLite('DESeq2')
        library(DESeq2)
}

library(ggplot2)
library(sva)

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

	nmale <- sum(phen$Sex == 'male')
	maleUse <- (rowSums(expr[, phen$Sex=='male'] > 10) >= 6 )
	nfemale <- sum(phen$Sex == 'female')
	femaleUse <- (rowSums(expr[, phen$Sex=='female'] > 10) >= 6 )

	expr <- expr[(maleUse | femaleUse),]
	print(dim(expr))

	dds <- DESeqDataSetFromMatrix(countData = expr, colData = phen, design = ~ Sex)
	dds <- estimateSizeFactors(dds)
	dat <- counts(dds, normalized=TRUE)

	mod <- model.matrix(~phen$Sex, colData(dds))
	mod0 <- model.matrix(~1, colData(dds))
	svseq <- svaseq(dat, mod, mod0, n.sv=2)

	ddssva <- dds
	rm(dds)
	ddssva$SV1 <- svseq$sv[,1]
	ddssva$SV2 <- svseq$sv[,2]
	design(ddssva) <- ~ SV1 + SV2 + Sex  
	ddssva <- DESeq(ddssva, parallel=T)
	
	return(ddssva)
                                                                                        
}

expr_df <- counts_df
rm(counts_df)

exp_stats <- expr_df[(nrow(expr_df)-4):nrow(expr_df),]
exprs <- expr_df[1:(nrow(expr_df)-5),]

deseq <- performDE(exprs, cond)
save(deseq, file=de_outfile)

deseq_results <- results(deseq, parallel=T)
deseq_results <- deseq_results[order(deseq_results$padj),]
save(deseq_results, file=res_outfile)
