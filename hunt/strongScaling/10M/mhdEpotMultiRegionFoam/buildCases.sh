#!/bin/bash

if [[ ! -d P_1 ]]
then
	echo "ERROR: no P_1 directory"
	exit
fi

maxCoresPerNode=112

coresAllBut1=(2 4 8 14 28 56 112 224 448 896)

for i in ${!coresAllBut1[@]}
do
  	cores=${coresAllBut1[i]}
	dir="P_$cores"
	if [ $cores -gt $maxCoresPerNode ]
	then
		coresPerNode=$maxCoresPerNode
		let nodes=$cores/$coresPerNode
		let remainder=$cores%$maxCoresPerNode
		if [ ! $remainder -eq 0 ]
		then
			 echo "WARNING: invalid choice of cores"
		fi
	else
		coresPerNode=$cores
		nodes=1
	fi

        if [[ ! -d $dir ]]
        then
		cp -r P_1 $dir
		sed -i s/<NP>/$cores/g $dir/system/decomposeParDict
		sed -i s/<NP>/$cores/g $dir/system/fluid/decomposeParDict
		sed -i s/<NP>/$cores/g $dir/system/walls/decomposeParDict
		sed -i s/"cores=1"/"cores=$cores"/g $dir/shercliff.sh
		sed -i s/"P_1"/"P_$cores"/g $dir/shercliff.peta4-icelake
       		sed -i s/"#SBATCH --ntasks-per-node=1"/"#SBATCH --ntasks-per-node=$coresPerNode"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --nodes=1"/"#SBATCH --nodes=$nodes"/g $dir/shercliff.peta4-icelake
        else
            	echo "Directory $dir already exists!"
        fi
done
