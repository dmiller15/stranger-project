#!/bin/bash -i

# Pass in the variables
script_dir=$1
tissue_type=$2
count_dir=$3
count_data=$4
phen_file=$5

source ~/.bashrc

echo "Matching count files to IDs"

export tissue_type

bash $script_dir/match_file_to_id.sh "$count_data"

echo "Generating phenotype object"

Rscript $script_dir/generate_phen_obj.R "$tissue_type" "$phen_file"

echo "Generating expression object"

Rscript $script_dir/generate_count_obj.R "$tissue_type" "$count_dir"

echo "Performing DE analysis" 
with_proxy Rscript $script_dir/perform_DE.R "$tissue_type"
