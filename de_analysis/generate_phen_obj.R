# Generates phenotype data frame for use with DESeq2
# rownames are TCGA IDs
# Columns are each covariate of interest

args <- commandArgs(TRUE)
tissue_type <- args[1]

source('variables.R')

phen_file <- args[2]

files_df <- read.table(file=paste(tissue_type,'count.files',sep='.'), header=T, stringsAsFactors=F, na.strings='', fill=T)
phens_df <- read.table(file=phen_file, header=F, stringsAsFactors=F, sep="\t", row.names=1)
colnames(phens_df) <- "gender"

ids_with_counts <- (!is.na(files_df$File))

phens <- phens_df[ids_with_counts,]
#cond <- phens[,'gender',drop=F]
#colnames(cond) <- 'Sex' # Rename gender to Sex

save(phens, file=phen_outfile)
