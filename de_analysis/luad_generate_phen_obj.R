files_dir <- '/mnt/data/gdc-mrna-counts/TCGA-LUAD'
phen_file <- '/mnt/data/tcga/tcga_phens/t.LUAD.txt'

files_df <- read.table(file='count.files', header=T, stringsAsFactors=F, na.strings='', fill=T)
phens_df <- read.table(file=phen_file, header=T, stringsAsFactors=F, sep="\t", row.names=1)

ids_with_counts <- (!is.na(files_df$File))

phens <- phens_df[ids_with_counts,]
cond <- phens[,'gender',drop=F]

save(cond, file='luad.phens.Robj')