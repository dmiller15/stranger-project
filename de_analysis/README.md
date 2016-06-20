# Sex biased DE analysis of TCGA data

Ensure you have pre-requisite files:

* Count files, downloaded from the Bionimbus objectstore `gdc-mrna-counts` bucket
* Phenotype files, downloaded from the Bionimbus objectstore `tcga` bucket

## Step 0: Edit the variables.R file

This file will be imported in steps 2-4 to easily allow the user to change which cancer type is tested and the location of input and output files.

## Step 1: Match available phenotypes with count data

For each individual we have phenotypes for, we must match the ID with the mRNA counts filename.

The `match` script takes the phenotype file and, in order, matches each ID with the count filename, if it exists.

## Step 2: Create an Robject for phenotype data

This Rscript takes the file created in Step 1 and, for each individual with a count file, creates a DESeq2-comptaible condition data frame.

## Step 3: Create an Robject for count data

This Rscript takes the file created in Step 1 and, for each individual with a count file, creates a DESeq2-comptaible gene expression data frame.

## Step 4: Perform the differential expression analysis

The `perform_DE` script runs the DESeq2 differential expression analysis via the following steps:

* Imports both the condition and count dataframes
* Filters genes based on expression.
** Separately for males and females: test whether a gene has counts > 10 in at least 6 individuals
** Separate tests are combined via OR, which ensures genes expressed in at least one sex are included
* Surrogate variables are estimated from the genes passing expression filter
** Variation due to sex accounted for
* Top two surrogate variables included in the DESeq2 model
** gene\_expr ~ Sex + SV1 + SV2
