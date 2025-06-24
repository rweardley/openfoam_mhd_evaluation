#!/bin/bash

# $(date +"%Y_%m_%d_%H%M-%p")

coresAll=(1 2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

echo -e "Case (leave blank for weakScaling): [80k/640k/10M]"
read caseDir

if [[ $caseDir == "" ]] || [[ $caseDir == "80k" ]] || [[ $caseDir == "640k" ]] || [[ $caseDir == "10M" ]]
then
	if [[ $caseDir == "10M" ]]
	then
		coresAll=(76 152 304 608 1216 1824 2204)
	fi
else
	echo "Invalid case"
	exit
fi

echo -e "Solver: [epotFoam/epotFoamCurrent/mhdFoamTimed]"
read solver

if [[ $solver == "epotFoam" ]] || [[ $solver == "epotFoamCurrent" ]] || [[ $solver == "mhdFoamTimed" ]]
then
    	if [[ $solver == "epotFoam" ]] || [[ $solver == "epotFoamCurrent" ]]; then
		script="epotFoam"
	elif [[ $solver == "mhdFoamTimed" ]]; then
		script="mhdFoam"
	fi
else
    	echo "Invalid solver"
        exit
fi

echo -e "Move? [enter 'move' or leave blank]"
read move

if [[ $move == "" ]] || [[ $move == "move" ]]
then
    	:
else
    	echo "Invalid move"
        exit
fi

if [[ $caseDir == "" ]]
then
	inDir="$solver"
	outDir="out/$solver.out_$(date +"%Y_%m_%d_%H%M")"
else
	inDir="$caseDir/$solver"
	outDir="out/$caseDir.$solver.out_$(date +"%Y_%m_%d_%H%M")"
fi

if [[ ! -d $outDir ]]
then
	mkdir -p $outDir
	echo $outDir
	mkdir -p $outDir/timing

	for cores in ${coresAll[@]}
	do
  		sourceDir="$inDir/P_$cores"
		echo $sourceDir
	        if [[ -d $sourceDir ]]
        	then
            		echo "Directory $sourceDir exists"
			solverlog="$sourceDir/log.$solver"
        	        if [[ -f $solverlog ]]
	                then
        	            	echo "Found $solverlog"
				./dataExtract_$script.sh $solverlog > $outDir/timing/P_$cores
	                else
        	            	echo "$solverlog not found"
                	fi

			if [[ $move = "move" ]]
			then
				mv $sourceDir $outDir
			fi
	        else
        	    	echo "Directory $sourceDir does not exist!"
	        fi
	done
else
	echo "Output directory $outDir already exists!"
fi
