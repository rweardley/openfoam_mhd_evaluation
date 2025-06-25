#!/bin/bash

# for folder in folders
# if folder exists, cd into folder, sbatch if it exists, then cd back out

coresAll=(28 56 112 224 448)

for cores in ${coresAll[@]}
do
	dir="P_$cores"
	if [[ -d $dir ]]
	then
		echo "Directory $dir exists"
		cd $dir
		if [[ -f hunt.sapphire ]]
		then
			sbatch hunt.sapphire
		else
			echo "No submission script found in $dir"
		fi
		cd ..
	else
		echo "Directory $dir does not exist!"
	fi
done
