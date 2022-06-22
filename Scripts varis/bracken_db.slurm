#!/bin/bash
#SBATCH --job-name=Bracken-inst
#SBATCH --output=bracken_install.out
#SBATCH --error=bracken_install.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH -p nodo.q
#SBATCH -w clus11


BRACKEN_PATH=/home/pfc/epineda/TFG_Esteve/bracken/Bracken

bash ${BRACKEN_PATH}/install_bracken.sh


KRAKEN_DB=/home/pfc/epineda/TFG_Esteve/bracken/Kraken
THREADS=12
KMER_LEN=35
READ_LEN=150
KRAKEN_INSTALLATION=/home/caos/bio-data/TOOLS/kraken2-2.0.8-beta/

${BRACKEN_PATH}/bracken-build -d ${KRAKEN_DB} -t ${THREADS} -k ${KMER_LEN} -l ${READ_LEN} -x ${KRAKEN_INSTALLATION}
