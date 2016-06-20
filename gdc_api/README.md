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

# Using the API

The API include several "endpoints" from which to request data:

* https://gdc-api.nci.nih.gov/projects 
* https://gdc-api.nci.nih.gov/files
* https://gdc-api.nci.nih.gov/cases

Additionally, appending the `/_mapping` suffix to the end returns all available parameters for each endpoint.

# Filtering output

The important part of the API call is restricting searches based on input data. In Python, specify boolean operations like so

```
filt = {
    'op':'=',
    "content":{
    "field": "files.file_name",
    "value": [<file.name>]
    }
}
```

Applying this filter to the call will return data where the associated file name is `<file.name>`. This script loops over a list of filenames in order to request metadata on each.

# Requesting output

The other important part of this script is specifying which data are returned:

```
params = {'fields':
	'files.cases.project.project_id,files.cases.samples.sample_type,files.cases.submitter_id,files.file_name,case_id',
	'filters':json.dumps(filt)
}
```

The `fields` argument specifies which data are returned. Arguments here correspond to ones returned from quering `_mapping` from an endpoint. The fields also determine how the final JSON output is organized. For example:

The results from a call to for `files.cases.project.project_id` info will be sorted into a `cases` dictionary contained in a `files` dictionary.

```
{'files':[
	{'cases':
		{'project.project_id':'TCGA-BRCA'}
	}]
}
```

Thus, you might have to explore all of the indicies of a returned JSON string in order to parse the indexes.
