# Sorting Downloaded files

By default, the gdc-client saves each file to its own directory:

```
/mnt/data/download:
    123abc/
        file.gz
    456def/
        file.gz
```

Create a new directory to upload:

`mkdir /mnt/data/to_upload`

Move downloaded files to this new directory

`find . -name "*.gz" -exec mv {} /mnt/data/to_upload`

 Change to the new directory and create a new file of filenames:

 `ls /mnt/data/to_upload/*.gz > files.txt`

 Edit the `gdc_api.py` script to pull in the created `filex.txt`
