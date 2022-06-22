#!/bin/bash

for a in 1-DV 2-DMe 3-DMo 5-LH 7-BT 8-AM;do
	originalFile=${a}-R1_trim.fastq
	for i in 500 400 300 200 100 50; do
		nLines=$(echo $i | awk '{print $1*1000*4}')
		head -n $nLines $originalFile > ${a}-R1_trim-${i}.fastq
	done
done
