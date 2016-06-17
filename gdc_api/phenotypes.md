# TCGA Phenotypes

Unfortunately, the GDC does not currently provide easily-usable phenotypes for each case.

Phenotypes and clinical data, in the form of CDE files, were downloaded from the Broad and uploaded to the `tcga` bucket on the Bionimbus object store.

These files are specific to each cancer type. The first column describes each covariate.

I recommend transposing each file so that each row corresponds to a case.

```
#this step now performed in the match_files shell script

cat <file> | datamash transpose > t.<file>
```
