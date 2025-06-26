#!/bin/bash

# $(date +"%Y_%m_%d_%H%M-%p")

coresAll=(1 2 4 8 14 28 56 112 224 336 448)

echo -e "Problem Size: [80k_20k/800k_200k]"
read caseSize

if [[ $caseSize == "80k_20k" ]] || [[ $caseSize == "800k_200k" ]]
then
	echo "Valid case size"
	# if [[ $caseSize == "80k_20k" ]]; then
	# 	PIMPLE_nCorrectors=2
	# elif [[ $caseSize == "800k_200k" ]]; then
	# 	PIMPLE_nCorrectors=3
	fi
else
	echo "Invalid case size"
	exit
fi

echo -e "Node Type: [spr/spr-hbm/spr-hbm-flat]"
read nodeType

if [[ $nodeType == "spr" ]] || [[ $nodeType == "spr-hbm" ]] || [[ $nodeType == "spr-hbm-flat" ]]
then
	echo "Valid node type"
else
	echo "Invalid node type"
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

solver="mhdEpotMultiRegionFoam"
script="$solver"
case="${solver}_${nodeType}"

inDir="$caseSize/$case"
outDir="out/$caseSize.$case.out_$(date +"%Y_%m_%d_%H%M")"

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
				# ./dataExtract_$script.sh $solverlog $PIMPLE_nCorrectors > $outDir/timing/P_$cores
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
