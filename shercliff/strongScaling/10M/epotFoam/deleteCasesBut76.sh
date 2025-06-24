#!/bin/bash

coresAllBut76=(152 304 608 1216 1824 2204)

for cores in ${coresAllBut76[@]}
do
  	dir="P_$cores"
        if [[ -d $dir ]]
        then
                rm -r $dir
        else
            	echo "Directory $dir does not exist!"
        fi
done

