#!/bin/bash


#SBATCH --job-name=abundance
#SBATCH --output=abundanceLib1.out
#SBATCH --error=abundanceLib1.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH -p nodo.q
#SBATCH -w clus07

gd_path=/home/pfc/epineda/TFG_Esteve/bio-data/OUTPUT/g-d_algorithm/SingleEnd_AllReads/MixedSppLib/WholeGenomes/MixedSppLib1

for a in 6-AE 4-BO 7-BT 8-AM 3-DMo 2-DMe;do

	BWA_path=/home/pfc/epineda/TFG_Esteve/bio-data/OUTPUT/BWA/SingleEnd_AllReads/MixedSppLib/WholeGenomes/k19_T30/MixedSppLib1/${a}_MixedSppLib1_F2308.sam
	i=0
	total=0
	while IFS= read -r line
	do
	  if [[ $i -ge 4 ]]; then
	        
		reference=$( echo $line | awk '{ print $1 }')
		if [[ $(cat $BWA_path | grep $reference | wc -l) -gt 0 ]]; then
			echo "Aqui entra $i"		
			reads=$(echo $line | awk '{print $2}' | perl -pe 's|.*?\(||' | perl -pe 's|\)||' | sed 's/|.*//')
			percent=$(echo $line | awk '{print $2}' | perl -pe 's|.*?\(||' | perl -pe 's|\)||' | sed 's/.*|//')
			total=$(echo $total $percent | awk '{print $1+$2}')
			echo "Total: $total"
		fi
	  fi
	  ((i++))
	done < $gd_path/BWA-k19-T30_g0.99-d0.98_MixedSppLib1.csv

	echo "${a} ($total)" >> abundanceLib1.txt

done
