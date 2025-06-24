#!/bin/bash

# $(date +"%Y_%m_%d_%H%M-%p")

coresAll=(1 2 4 6 12 18 38 76 152 304 608 1216 1824 2204)

echo -e "Strong or Weak Scaling? [strong/weak]"
read scalingType
if [[ $scalingType == "strong" ]]; then
	scalingDir="../strongScaling"
	echo -e "Case: [80k/640k/10M]"
	read caseDir
elif [[ $scalingType == "weak" ]]; then
	scalingDir="../weakScaling"
	caseDir=""
else
	echo "Invalid scaling type"
	exit
fi


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

echo -e "Solver Directory Name (the name of the directory containing P_* cases):"
read solverDir

echo -e "Solver Log Name (the name of the log.<solver> file - specify <solver>):"
read solverLogName

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
	inDir="$scalingDir/$solverDir"
	outDir="$scalingDir/out/$solverDir.out_$(date +"%Y_%m_%d_%H%M")"
else
	inDir="$scalingDir/$caseDir/$solverDir"
	outDir="$scalingDir/out/$caseDir.$solverDir.out_$(date +"%Y_%m_%d_%H%M")"
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
			solverlog="$sourceDir/log.$solverLogName"
        	        if [[ -f $solverlog ]]
	                then
        	            	echo "Found $solverlog"
				dataExtract_PIMPLE_basic.sh $solverlog > $outDir/timing/P_$cores
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
