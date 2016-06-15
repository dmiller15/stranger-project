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
#dds <- DESeq(dds, parallel=T)
#return(dds)
# Estimate surrogate variables
#dds <- estimateSizeFactors(dds)
#print(head(dat))
mod <- model.matrix(~phen$gender, colData(dds))
mod0 <- model.matrix(~1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv=2)
# svseq$sv: matrix of SVs
# svseq$n.sv: number of SVs

ddssva <- dds
ddssva$SV1 <- svseq$sv[,1]
ddssva$SV2 <- svseq$sv[,2]
design(ddssva) <- ~ SV1 + SV2 + gender  
ddssva <- DESeq(ddssva, parallel=T)
#res <- results(ddssva, parallel=T)
return(ddssva)
                                                                                        
}

if (!require(DESeq2)) {
        library(BiocInstaller)
        biocLite('DESeq2')
        library(DESeq2)
}

library(ggplot2)
library(sva)

library(BiocParallel)
register(MulticoreParam(4))

load('luad.counts.Robj')
load('luad.phens.Robj')

expr_df <- counts_df
rm(counts_df)

exp_stats <- expr_df[(nrow(expr_df)-4):nrow(expr_df),]
exprs <- expr_df[1:(nrow(expr_df)-5),]

luad_deseq <- performDE(exprs, cond)
save(thca_deseq, file='luad_de.Robj')

luad_results <- results(luad_deseq, parallel=T)
luad_results <- thca_results[order(luad_results$padj),]
save(luad_results, file='luad_results.Robj')