# Generates phenotype data frame for use with DESeq2
# rownames are TCGA IDs
# Columns are each covariate of interest

args <- commandArgs(TRUE)
tissue_type <- args[1]
count_dir <- args[2]

source('variables.R')

files_df <- read.table(file=paste(tissue_type,'count.files',sep='.'), header=T, stringsAsFactors=F, na.strings='', fill=T)

all_ids <- NULL
all_counts <- list()
for (i in seq(nrow(files_df))) {
        id <- files_df$ID[i]
        f_in <- files_df$File[i]

        if (!is.na(f_in)) {
                count_file <- paste(count_dir, f_in, sep='/')
                x <- read.table(count_file, header=T, sep='\t', row.names=1, stringsAsFactors=F)
                all_counts[[i]] <- data.frame(x)
                all_ids <- c(all_ids, id)

        } else {
                all_counts[[i]] <- NA
        }
}

counts_df <- data.frame(row.names=rownames(all_counts[[1]]))
for (i in seq(length(all_counts))) {
        if (!is.na(all_counts[[i]])) counts_df <- data.frame(counts_df, all_counts[[i]])
}

colnames(counts_df) <- all_ids

#counts_df <- counts_df[(nrow(counts_df)-4):nrow(counts_df),]
counts_df <- counts_df[1:(nrow(counts_df)-5),] # Remove last rows, which contain alignment stats

use <- (rowSums(counts_df)>0)
counts_df <- counts_df[use, ]
save(counts_df, file=count_outfile)
