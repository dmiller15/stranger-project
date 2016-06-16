# Downloading GDC Data

Requirements

* GDC Access
* TCGA dbGaP access, if downloading protected data
* gdc-client [binary](https://gdc.nci.nih.gov/access-data/gdc-data-transfer-tool) downloaded to your system

Visit the GDC website and select desired files to download. Then download the manifest from the "Summary" tab.

Move both the gdc-client binary and the manifest file (and the token file if required) to a virtual machine with ephemeral storage.

# Preparing the VM

Create a new directory for downloaded files

```
sudo mkdir -p /mnt/data/download
sudo chown -R ubuntu:ubuntu /mnt/data
```

# Downloading the files

You must run the gdc-client with the proxy.

I run the following command

`time with_proxy gdc-client download --no-related-files --no-annotations -t /path/to/token -m /path/to/manifest 2>out.txt &`

This runs the download as a separate process, so you can run other commands or sign off and it still runs. The output is also piped to a txt file. Once the command runs, the time elapsed will be printed to the terminal.
