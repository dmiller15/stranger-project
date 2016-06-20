# Generates phenotype data frame for use with DESeq2
# rownames are TCGA IDs
# Columns are each covariate of interest

# source('r_variables.R')
cancer_type <- 'LUAD'
dir_prefix <- '/mnt/data/'
out_file <- paste('cancer_type', '.counts.Robj')

files_dir <- paste(dir_prefix, 'gdc-mrna-counts/TCGA-', cancer_type, sep='')
files_df <- read.table(file='count.files', header=T, stringsAsFactors=F, na.strings='', fill=T)

all_ids <- NULL
all_counts <- list()
for (i in seq(nrow(files_df))) {
        id <- files_df$ID[i]
        f_in <- files_df$File[i]

        if (!is.na(f_in)) {
                count_file <- paste(files_dir, f_in, sep='/')
                x <- read.table(file=count_file, header=F, row.names=1, stringsAsFactors=F)
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
save(counts_df, file=out_file)