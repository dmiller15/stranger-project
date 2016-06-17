# GDC API

The GDC API, described at [https://gdc.nci.nih.gov/developers/gdc-application-programming-interface-api](https://gdc.nci.nih.gov/developers/gdc-application-programming-interface-api) , allows programatic access to GDC data. 

This is most useful now for gathering the meta-data of files downloaded via the `gdc-client`, especially bulk downloads.

As of now, when downloading multiple files via the `gdc-client`, each file is saved to its own directory and, for most files, also have a unique, UUID name. This name is not descriptive of any meta-data, i.e. which case, sample type, or project id. Thus, sorting files is impossible.

The meta-data currently returned are:

* Project ID
* File name
* Tissue source
* TCGA Case ID

The Python script in this directory queries the GDC API, which returns a JSON-formatted string interpretable via the Python `json` package. The JSON string is parsed into nested dictionaries and lists, which can be indexed to obtain desired information.

When given the file name, the API returns other information based on the TCGA subject that file is from. Other data include all other files (mRNA counts, NGS data, etc). The python script matches the given file name with one of the returned file names. Meta-data for that file name include the tissue source (Primary Tumor, Solid Tissue Normal, etc), and TCGA Case ID.
