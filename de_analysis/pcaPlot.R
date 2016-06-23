source('variables.R')

library(ggplot2)
library(gplots)

load(paste(cancer_type,'count.Robj', sep="_"))
load(paste(cancer_type,'phen.Robj', sep="_"))

pcaOut <- prcomp(t(count_df), scale=T)
pcaOut <- pcaOut[,1:20]
