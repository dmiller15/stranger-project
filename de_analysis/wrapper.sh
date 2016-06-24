#!/bin/bash -i

script_dir=/mnt/data/osdc-docs/de_analysis
#cd /mnt/data

source ~/.bashrc

echo "Matching count files to IDs"

sh $script_dir/match_file_to_id.sh

echo "Generating phenotype object"

Rscript --vanilla $script_dir/generate_phen_obj.R

echo "Generating expression object"

Rscript --vanilla $script_dir/generate_count_obj.R

echo "Performing DE analysis"
with_proxy Rscript $script_dir/perform_DE.R
