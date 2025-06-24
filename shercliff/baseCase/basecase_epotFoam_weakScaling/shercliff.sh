#!/bin/bash

source ~/.openfoam9_profile

cores=1

blockMesh_start=$(date +%s.%3N)
blockMesh 2>&1 | tee log.blockMesh
blockMesh_end=$(date +%s.%3N)
blockMesh_elapsed=$(echo "scale=3; $blockMesh_end - $blockMesh_start" | bc)
echo -e "blockMesh \t" + $blockMesh_elapsed > log.timings

if [[ ! $cores -eq 1 ]]
then
	decomposePar_start=$(date +%s.%3N)
	decomposePar 2>&1 | tee log.decomposePar
	decomposePar_end=$(date +%s.%3N)
	decomposePar_elapsed=$(echo "scale=3; $decomposePar_end - $decomposePar_start" | bc)
	echo -e "decomposePar \t" + $decomposePar_elapsed >> log.timings
fi

if [[ $cores -eq 1 ]]
then
	run="epotFoam"
else
	run="mpirun -np $cores --display-map epotFoam -parallel"
fi

epotFoam_start=$(date +%s.%3N)
eval $run 2>&1 | tee log.epotFoam
epotFoam_end=$(date +%s.%3N)
epotFoam_elapsed=$(echo "scale=3; $epotFoam_end - $epotFoam_start" | bc)
echo -e "epotFoam \t" + $epotFoam_elapsed >> log.timings

if [[ ! $cores -eq 1 ]]
then
	reconstructPar_start=$(date +%s.%3N)
	reconstructPar 2>&1 | tee log.reconstructPar
	reconstructPar_end=$(date +%s.%3N)
	reconstructPar_elapsed=$(echo "scale=3; $reconstructPar_end - $reconstructPar_start" | bc)
	echo -e "reconstructPar \t" + $reconstructPar_elapsed >> log.timings
fi

