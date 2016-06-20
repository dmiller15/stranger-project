#!/bin/bash

script_dir=/mnt/data/osdc-docs/de_analysis
#cd /mnt/data

sh $script_dir/match_file_to_id.sh

Rscript --vanilla $script_dir/generate_phen_obj.R

Rscript --vanilla $script_dir/generate_count_obj.R

Rscript --vanilla $script_dir/perform_DE.R
