#!/bin/bash

if [[ ! -d P_1 ]]
then
	echo "ERROR: no P_1 directory"
	exit
fi

maxCoresPerNode=76

coresAllBut1=(2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

resolutionAll=(
	"(62 25 13)"	# 2
	"(78 32 16)"	# 4
	"(93 36 18)"	# 6
	"(113 46 23)"	# 12
	"(133 52 26)"	# 18
	"(167 67 34)"	# 38
	"(213 85 42)"	# 76
	"(268 107 53)"	# 152
	"(339 134 67)"	# 304
	"(423 169 85)"	# 608
	"(534 213 107)"	# 1216
	"(613 244 122)"	# 1824
	"(652 260 130)"	# 2204
)

timestepsAll=(
	"0.127"		# 2
	"0.1008"	# 4
	"0.088"		# 6
	"0.0698"	# 12
	"0.061"		# 18
	"0.0476"	# 38
	"0.0378"	# 76
	"0.03"		# 152
	"0.0238"	# 304
	"0.01888"	# 608
	"0.015"		# 1216
	"0.0131"	# 1824
	"0.0123"	# 2204
)

baseResolution="(50 20 10)"
baseTimestep="deltaT          0.16"

for i in ${!coresAllBut1[@]}
do
  	cores=${coresAllBut1[i]}
	subdomains=${subdomainsAll[i]}
	resolution=${resolutionAll[i]}
	timestep=${timestepsAll[i]}
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
		sed -i s/"n               (1 1 1)"/"n               $subdomains"/g $dir/system/decomposeParDict
		sed -i s/"cores=1"/"cores=$cores"/g $dir/shercliff.sh
		sed -i s/"-np 1"/"-np $cores"/g $dir/shercliff.sh
		sed -i s/"P_1"/"P_$cores"/g $dir/shercliff.peta4-icelake
       		sed -i s/"#SBATCH --ntasks-per-node=1"/"#SBATCH --ntasks-per-node=$coresPerNode"/g $dir/shercliff.peta4-icelake
		sed -i s/"#SBATCH --nodes=1"/"#SBATCH --nodes=$nodes"/g $dir/shercliff.peta4-icelake
		sed -i s/"hex (0 1 2 3 4 5 6 7) $baseResolution"/"hex (0 1 2 3 4 5 6 7) $resolution"/g $dir/system/blockMeshDict
		sed -i s/"$baseTimestep"/"deltaT          $timestep"/g $dir/system/controlDict
        else
            	echo "Directory $dir already exists!"
        fi
done
