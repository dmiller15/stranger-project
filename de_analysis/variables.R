#cancer_type <- 'LUAD'

setwd(cancer_type)

dir_prefix <- '/mnt/data'
phen_outfile <- paste(cancer_type, 'phen.Robj', sep="_")
count_outfile <- paste(cancer_type, 'count.Robj', sep="_")

#paste(cancer_type, 'count.files', sep='.')
de_outfile <- paste(cancer_type, 'de.Robj', sep="_")
res_outfile <- paste(cancer_type, 'res.Robj', sep="_")

mrna_files_dir <- paste(dir_prefix, '/gdc-mrna-counts/TCGA-', cancer_type, sep='')
phen_file <- paste(dir_prefix, '/tcga/tcga_phens/t.', cancer_type, '.txt', sep='')

Sys.setenv(http_proxy='http://cloud-proxy:3128')
