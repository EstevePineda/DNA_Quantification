#!/bin/bash

#SBATCH --job-name=kraken_Mixed
#SBATCH --output=kraken_Mixed.out
#SBATCH --error=kraken_Mixed.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH -p nodo.q
#SBATCH -w clus01


mkdir -p /home/pfc/epineda/pruebaKraken/workdir/
WK_DIR=/home/pfc/epineda/pruebaKraken/workdir/
cd ${WK_DIR}

#Software Kraken path
KRAKEN2=/home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2
# Kraken DataBase path
#KRAKEN_DB=/home/caos/bio-data/DATA/whole_genomes/kraken/DB_without_no-masking
KRAKEN_DB=/home/caos/bio-data/Kraken_data/data_5G/kraken_db_with_no_masking_1

PYTHON_SCRIPT=/home/pfc/epineda/TFG_Esteve/kraken_scripts/extract_kraken_reads.py

#Para los taxid, vamos a crear un vector con los numeros de forma automatizada
declare -A FAMILIES
FAMILIES=()
/home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-inspect --db $KRAKEN_DB | awk '$4 ~ /F/ && length($4) == 1 {print}' > familiesTaxids.txt

while IFS= read -r fila
do
	family=$(echo $fila | awk '{print $6}')
        taxid=$(echo $fila | awk '{print $5}')
        FAMILIES+=([$family]=$taxid)
done < familiesTaxids.txt

SAMPLE_PATH=/home/caos/bio-data/DATA/mixed_spp_lib/SE_trim_len150_minlen140

for lib in {1..6}; do
#for lib in 6; do
	file2map=${SAMPLE_PATH}/MixedSppLib${lib}-R1_trim.fastq

        $KRAKEN2 --DB $KRAKEN_DB $file2map --output MixedSppLib${lib}-R1_trim.kraken --report MixedSppLib${lib}-R1_trim.report
        reportFile=MixedSppLib${lib}-R1_trim.report
        CLASSIFIED=MixedSppLib${lib}-R1_trim.kraken

        # Generamos arrays con declare y luego incorporamos a estos array los archivos mediante las path
        declare -a SEQ_FILE
        SEQ_FILE=()
        SEQ_FILE+=($(readlink -f $file2map))
        declare -a REPORT
        REPORT=()
        REPORT+=($(readlink -f $reportFile))

        python3.6 $PYTHON_SCRIPT -k $CLASSIFIED -s ${SEQ_FILE[$num]} -o MixedSppLib${lib}-R1_trim.fastq -t ${FAMILIES[@]} --include-children -r ${REPORT[$num]} --fastq-output
done
