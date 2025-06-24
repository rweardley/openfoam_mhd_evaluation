#!/bin/bash

# for folder in folders
# if folder exists, cd into folder, sbatch if it exists, then cd back out

coresAll=(1 2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

for cores in ${coresAll[@]}
do
	dir="P_$cores"
	if [[ -d $dir ]]
	then
		echo "Directory $dir exists"
		cd $dir
		if [[ -f shercliff.peta4-icelake ]]
		then
			sbatch shercliff.peta4-icelake
		else
			echo "No submission script found in $dir"
		fi
		cd ..
	else
		echo "Directory $dir does not exist!"
	fi
done
