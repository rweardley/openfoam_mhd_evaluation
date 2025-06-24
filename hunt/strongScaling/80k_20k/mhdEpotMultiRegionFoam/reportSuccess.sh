#!/bin/bash

coresAll=(1 2 4 8 14 28 56 112 224 448)

for cores in ${coresAll[@]}
do
  	dir="P_$cores"
        if [[ -d $dir ]]
        then
                if [[ -d "$dir/1" && -d "$dir/2" ]]
                then
                    	echo "$dir: Success"
                else
                   	echo "$dir: Failed or still running"
                fi
		while read -r -a columns; do
		if [[ ${columns[0]} == "epotFoam" ]] || [[ ${columns[0]} == "epotFoamCurrent" ]] || [[ ${columns[0]} == "mhdFoamTimed" ]] || [[ ${columns[0]} == "mhdEpotMultiRegionFoam" ]]; then
			echo "Solve time: ${columns[2]}"
		fi
		done <$dir/log.timings
        else
            	echo "Directory $dir does not exist!"
        fi
done


