#!/bin/bash -i

script_dir=/mnt/data/osdc-docs/de_analysis
#cd /mnt/data

source ~/.bashrc

echo "Matching count files to IDs"

cancer_type='ACC'
export cancer_type

bash $script_dir/match_file_to_id.sh

echo "Generating phenotype object"

Rscript $script_dir/generate_phen_obj.R "$cancer_type"

echo "Generating expression object"

Rscript $script_dir/generate_count_obj.R "$cancer_type"

echo "Performing DE analysis"
with_proxy Rscript $script_dir/perform_DE.R "$cancer_type"
