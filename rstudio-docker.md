# Create Rstudio docker with bioinformatics packages

Use the Rstudio image as a base

`docker pull rocker/rstudio`

Run a bash shell as root

`docker run --user root -it rocker/rstudio /bin/bash`

Update package repos

`apt-get update`

Install hadleyverse recommended packages and libraries

```
apt-get install -y --no-install-recommends -t unstable \
    default-jdk \
    default-jre \
    gdal-bin \
    icedtea-netx \
    libatlas-base-dev \
    libcairo2-dev \
    libgsl0-dev \
    libgdal-dev \
    libgeos-dev \
    libgeos-c1v5 \
    librdf0-dev \
    libssl-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    librsvg2-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    netcdf-bin \
    qpdf \
    r-cran-rgl \
    ssh \
    vim
```