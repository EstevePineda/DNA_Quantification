#!/bin/bash

for a in {0..5};do
	originalFile=${a}-*trim.fastq
	totalReads=$(echo $(cat ${originalFile} | wc -l) | awk '{print $1/4}')
	for i in 100 75 50 25; do
		nReads=$(echo $totalReads $i | awk '{print $1*($2/100)}')
		nLines=$(echo $nReads | awk '{print $1*4}')
		head -n $nLines $originalFile > ${a}-*trim-${i}.fastq
	done
done
