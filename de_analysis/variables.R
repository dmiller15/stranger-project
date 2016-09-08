#cancer_type <- 'LUAD'

setwd(cancer_type)

dir_prefix <- '/mnt/data'
phen_outfile <- paste(tissue_type, 'phen.Robj', sep="_")
count_outfile <- paste(tissue_type, 'count.Robj', sep="_")

#paste(tissue_type, 'count.files', sep='.')
de_outfile <- paste(tissue_type, 'de.Robj', sep="_")
res_outfile <- paste(tissue_type, 'res.Robj', sep="_")

Sys.setenv(http_proxy='http://cloud-proxy:3128')
