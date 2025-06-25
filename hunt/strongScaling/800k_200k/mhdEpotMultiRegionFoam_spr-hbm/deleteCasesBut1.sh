#!/bin/bash

coresAllBut1=(2 4 8 14 28 56 112 224 336 448)

for cores in ${coresAllBut1[@]}
do
  	dir="P_$cores"
        if [[ -d $dir ]]
        then
                rm -r $dir
        else
            	echo "Directory $dir does not exist!"
        fi
done

