# Script to match each case ID present in the Broad TCGA CDE file with an mRNA count file from the GDC
# Returns a 2 column file: file_name	case_id

cancer_type="LUAD"

path_prefix='/mnt/data'
count_dir="$path_prefix/gdc-mrna-counts/TCGA-$cancer_type"
count_data="/mnt/data/gdc-mrna-counts/mrna_data.txt"

phen_data="$path_prefix/tcga/tcga_phens/t.$cancer_type.txt"

# Create transposed file if doesn't exist
if [ ! -f "$phen_data" ];
then
	cat $path_prefix/tcga/tcga_phens/$cancer_type.clin.merged.picked.txt | datamash transpose > $phen_data
fi

grep $cancer_type $count_data | grep "Primary Tumor" > $cancer_type.primary.files.txt
grep $cancer_type $count_data | grep Normal > $cancer_type.normal.files.txt

echo "ID\tFile" > count.files
while read line; do
        tcga_id=$line
        file_line=$(cat LUAD.primary.files.txt | tr '[:upper:]' '[:lower:]' | grep $tcga_id)
        f=$(echo $file_line | cut -d ' ' -f 2)
        echo "$tcga_id\t$f" >> count.files
done < ids.txt