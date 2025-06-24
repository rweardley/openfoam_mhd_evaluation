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
	"0.00635"	# 2
	"0.00504"	# 4
	"0.0044"	# 6
	"0.00349"	# 12
	"0.00305"	# 18
	"0.00238"	# 38
	"0.00189"	# 76
	"0.0015"	# 152
	"0.00119"	# 304
	"0.000944"	# 608
	"0.00075"	# 1216
	"0.000655"	# 1824
	"0.000615"	# 2204
)

baseResolution="(50 20 10)"
baseTimestep="deltaT          0.008;"

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
		sed -i s/"deltaT          0.008"/"deltaT          $timestep"/g $dir/system/controlDict
        else
            	echo "Directory $dir already exists!"
        fi
done
