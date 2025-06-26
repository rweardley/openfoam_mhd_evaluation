#!/bin/bash

# $(date +"%Y_%m_%d_%H%M-%p")

coresAll=(1 2 4 8 14 28 56 112 224 336 448)

echo -e "Case (leave blank for weakScaling): [80k/800k]"
read caseDir

if [[ $caseDir == "80k" ]] || [[ $caseDir == "800k" ]]
then
	echo "Valid case"
else
	echo "Invalid case"
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

script="mhdEpotMultiRegionFoam"
solver="mhdEpotMultiRegionFoam"

inDir="$caseDir/$solver"
outDir="out/$caseDir.$solver.out_$(date +"%Y_%m_%d_%H%M")"

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
