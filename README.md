# OSDC/Bionimbus

Openscience Data Cloud/Bionimbus are "cloud-based infrastructure for managing, analyzing, archiving and sharing scientific data sets" [OSDC Introduction](https://www.opensciencedatacloud.org/support/intro.html).

For a quick setup tutorial, check out the document [here]().

# Genomic Data Commons and Bionimbus

The easiest and most compliant way of working with the GDC's TCGA data is through Bionimbus, the protected data cloud component of OSDC. Each lab group using Bionimbus has access to a secure, S3-compatible objectstore, where protected data can be copied to and downloaded from. Combining this object storage with Bionimbus virtual machines (VMs) is the best way to analyze said data.

## Stored Data

As of Monday, 20 June 2016, the Stranger Lab object storage has the following GDC/TCGA data.

Additionally, the GDC manifests used to download these data are available [here]().

### Phenotypes

The GDC does not currently provide user-friendly phenotype files for download. Instead, TCGA phenotypes from the Broad are available in the `tcga` bucket.

Each project has it's own file with metadata for all individuals within that project, the first column of which lists all the covariates. For ease of use, consider transposing the file so each line represents a different individual.

`cat <file.txt> | datamash transpose`

### mRNA Counts

11,093 HTseq count files from 10,237 cases across 33 TCGA projects

These data are stored in the `gdc-mrna-counts` bucket, organized by project. 

At the top level of this bucket is a meta-data file for each count file. Importantly, this file links each file to its tissue source and individual.

### miRNA Counts

10,999 miRNA count files from 10,165 cases across 33 TCGA projects.

These data are stored in the `gdc-mirna-counts` bucket.

### Somatic Variants

Currently, files from 3 different experimental methods for calling somatic variants were downloaded, each with >11,000 files across 10,429 cases.

* SomaticSniper (11,130 files)
* Varscan2 (11,128)
* muse (11,120)

Additionally, 11,128 files from the MuTect2 workflow are available, but not yet downloaded.

### Copy Number Variation

16,567 files from 8,131 cases across 24 projects.
