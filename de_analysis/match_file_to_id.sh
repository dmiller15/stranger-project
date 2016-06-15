cancer_type="LUAD"

count_dir="/mnt/data/gdc-mrna-counts/TCGA-$cancer_type"
phen_data="/mnt/data/tcga/tcga_phens/t.LUAD.txt"

count_data="/mnt/data/gdc-mrna-counts/mrna_data.txt"

grep $cancer_type $count_data | grep "Primary Tumor" > $cancer_type.primary.files.txt
grep $cancer_type $count_data | grep Normal > $cancer_type.normal.files.txt


echo "ID\tFile" > count.files
while read line; do
        tcga_id=$line
        file_line=$(cat LUAD.primary.files.txt | tr '[:upper:]' '[:lower:]' | grep $tcga_id)
        f=$(echo $file_line | cut -d ' ' -f 2)
        echo "$tcga_id\t$f" >> count.files
done < ids.txt