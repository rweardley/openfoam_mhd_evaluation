#!/bin/bash

solver=epotFoamBuoyant

coresAll=(1 2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

for cores in ${coresAll[@]}
do
  	dir="P_$cores"
        if [[ -d $dir ]]
        then
                if [ -d "$dir/"[1-2]* ]
                then
                    	echo "$dir: Success"
                else
                   	echo "$dir: Failed or still running"
                fi
		while read -r -a columns; do
		if [[ ${columns[0]} == $solver ]]; then
			echo "Solve time: ${columns[2]}"
		fi
		done <$dir/log.timings
        else
            	echo "Directory $dir does not exist!"
        fi
done


