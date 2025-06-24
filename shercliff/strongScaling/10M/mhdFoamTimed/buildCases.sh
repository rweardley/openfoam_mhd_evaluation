#!/bin/bash

if [[ ! -d P_76 ]]
then
	echo "ERROR: no P_76 directory"
	exit
fi

maxCoresPerNode=76

coresAllBut76=(152 304 608 1216 1824 2204)

walltimesAll=(
	"18:00:00"	# 152
	"09:00:00"	# 304
	"04:30:00"	# 608
	"03:00:00"	# 1216
	"02:30:00"	# 1824
	"02:30:00"	# 2204
)

for i in ${!coresAllBut76[@]}
do
  	cores=${coresAllBut76[i]}
	walltime=${walltimesAll[i]}
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
		cp -r P_76 $dir
		sed -i s/"numberOfSubdomains 76"/"numberOfSubdomains $cores"/g $dir/system/decomposeParDict
		sed -i s/"cores=76"/"cores=$cores"/g $dir/shercliff.sh
		sed -i s/"P_76"/"P_$cores"/g $dir/shercliff.peta4-icelake
       		sed -i s/"#SBATCH --ntasks-per-node=76"/"#SBATCH --ntasks-per-node=$coresPerNode"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --nodes=1"/"#SBATCH --nodes=$nodes"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --time=36:00:00"/"#SBATCH --time=$walltime"/g $dir/shercliff.peta4-icelake
        else
            	echo "Directory $dir already exists!"
        fi
done
