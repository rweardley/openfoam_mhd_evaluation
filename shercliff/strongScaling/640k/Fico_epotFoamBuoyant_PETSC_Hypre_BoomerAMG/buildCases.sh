#!/bin/bash

if [[ ! -d P_1 ]]
then
	echo "ERROR: no P_1 directory"
	exit
fi

maxCoresPerNode=76

coresAllBut1=(2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

walltimesAll=(
	"08:00:00"	# 2
	"04:00:00"	# 4
	"03:00:00"	# 6
	"01:00:00"	# 12
	"01:00:00"	# 18
	"01:00:00"	# 38
	"01:00:00"	# 76
	"01:00:00"	# 152
	"01:00:00"	# 304
	"01:00:00"	# 608
	"01:00:00"	# 1216
	"01:00:00"	# 1824
	"01:00:00"	# 2204
)

for i in ${!coresAllBut1[@]}
do
  	cores=${coresAllBut1[i]}
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
		cp -r P_1 $dir
		sed -i s/"numberOfSubdomains 1"/"numberOfSubdomains $cores"/g $dir/system/decomposeParDict
		sed -i s/"cores=1"/"cores=$cores"/g $dir/shercliff.sh
		sed -i s/"P_1"/"P_$cores"/g $dir/shercliff.peta4-icelake
       		sed -i s/"#SBATCH --ntasks-per-node=1"/"#SBATCH --ntasks-per-node=$coresPerNode"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --nodes=1"/"#SBATCH --nodes=$nodes"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --time=10:00:00"/"#SBATCH --time=$walltime"/g $dir/shercliff.peta4-icelake
        else
            	echo "Directory $dir already exists!"
        fi
done
