# Generates phenotype data frame for use with DESeq2
# rownames are TCGA IDs
# Columns are each covariate of interest

args <- commandArgs(TRUE)
cancer_type <- args[1]

source('variables.R')

files_dir <- paste(dir_prefix, '/gdc-mrna-counts/TCGA-', cancer_type, sep='')
phen_file <- paste(dir_prefix, '/tcga/tcga_phens/t.', cancer_type, '.txt', sep='')

files_df <- read.table(file=paste(cancer_type,'count.files',sep='.'), header=T, stringsAsFactors=F, na.strings='', fill=T)
phens_df <- read.table(file=phen_file, header=T, stringsAsFactors=F, sep="\t", row.names=1)

ids_with_counts <- (!is.na(files_df$File))

phens <- phens_df[ids_with_counts,]
#cond <- phens[,'gender',drop=F]
#colnames(cond) <- 'Sex' # Rename gender to Sex

save(phens, file=phen_outfile)
