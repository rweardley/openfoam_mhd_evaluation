#!/bin/bash

source ~/.openfoam_v2306_sapphire_rocky9_profile

SOLVER="mhdEpotMultiRegionFoam"

cores=1

blockMesh_start=$(date +%s.%3N)

blockMesh -region fluid  2>&1 | tee log.blockMesh_fluid
blockMesh -region walls  2>&1 | tee log.blockMesh_walls

blockMesh_end=$(date +%s.%3N)
blockMesh_elapsed=$(echo "scale=3; $blockMesh_end - $blockMesh_start" | bc)
echo -e "blockMesh \t" + $blockMesh_elapsed > log.timings

if [[ ! $cores -eq 1 ]]
then
	decomposePar_start=$(date +%s.%3N)
	decomposePar -allRegions  2>&1 | tee log.decomposePar
	decomposePar_end=$(date +%s.%3N)
	decomposePar_elapsed=$(echo "scale=3; $decomposePar_end - $decomposePar_start" | bc)
	echo -e "decomposePar \t" + $decomposePar_elapsed >> log.timings
fi

if [[ $cores -eq 1 ]]
then
	run=$SOLVER
else
	run="mpirun -np $cores --map-by numa numactl --preferred-many=8-15 $SOLVER -parallel"
fi

epotFoamCurrent_start=$(date +%s.%3N)
eval $run 2>&1 | tee log.$SOLVER
epotFoamCurrent_end=$(date +%s.%3N)
epotFoamCurrent_elapsed=$(echo "scale=3; $epotFoamCurrent_end - $epotFoamCurrent_start" | bc)
echo -e "$SOLVER \t" + $epotFoamCurrent_elapsed >> log.timings

if [[ ! $cores -eq 1 ]]
then
	reconstructPar_start=$(date +%s.%3N)
	reconstructPar -allRegions 2>&1 | tee log.reconstructPar
	reconstructPar_end=$(date +%s.%3N)
	reconstructPar_elapsed=$(echo "scale=3; $reconstructPar_end - $reconstructPar_start" | bc)
	echo -e "reconstructPar \t" + $reconstructPar_elapsed >> log.timings
fi

