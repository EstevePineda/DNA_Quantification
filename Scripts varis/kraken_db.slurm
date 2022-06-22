#!/bin/bash
#SBATCH --job-name=Kraken2_DB
#SBATCH --nodes=1
#SBATCH --ntasks-per-socket=1
#SBATCH --sockets-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --output=kraken_build_db.out
#SBATCH --error=kraken_build_db.err
#SBATCH -p nodo.q
#SBATCH -w clus11
#SBATCH --exclusive


#export KRAKEN_DB=/home/caos/bio-data/DATA/whole_genomes/kraken/DB_without_no-masking
export KRAKEN_DB=/home/pfc/epineda/TFG_Esteve/kraken_db_without_no_masking
mkdir -p ${KRAKEN_DB}

time /home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-build --download-taxonomy --use-ftp --db ${KRAKEN_DB} --threads 12

cd /home/caos/bio-data/DATA/whole_genomes/kraken/renamed_whole_genomes

for seq in *.fasta; do
        time /home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-build --threads 12 --add-to-library ${seq} --db ${KRAKEN_DB}
done


#time /home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-build --build --db ${KRAKEN_DB} --max-db-size 7500000
time /home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-build --build --db ${KRAKEN_DB} --max-db-size 8589934592 #max-db-size 8GB
time /home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/kraken2-build --db ${KRAKEN_DB} --clean
