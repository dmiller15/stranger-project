# Parses out count files specific to the tissue type
# Returns a 2 column file: case_id"\t"file_name

# Make new dir and move there
mkdir -p $tissue_type
cd $tissue_type/

# Pass in the count data file
count_data=$1

# Just grep out the files for the tissue type from the phen_data file
echo -e "ID\tFile" > $tissue_type.count.files
grep $tissue_type $count_data | awk '{print $3"\t"$2}' >> $tissue_type.count.files
