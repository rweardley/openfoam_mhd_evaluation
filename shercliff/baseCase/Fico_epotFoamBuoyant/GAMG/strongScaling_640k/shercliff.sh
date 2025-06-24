#!/bin/bash

source ~/.openfoam_v2212_profile

cores=1
solver="epotFoamBuoyant"

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
	run=$solver
else
	run="mpirun -np $cores $solver -parallel"
fi

solver_start=$(date +%s.%3N)
eval $run 2>&1 | tee log.$solver
solver_end=$(date +%s.%3N)
solver_elapsed=$(echo "scale=3; $solver_end - $solver_start" | bc)
echo -e "$solver \t" + $solver_elapsed >> log.timings

if [[ ! $cores -eq 1 ]]
then
	reconstructPar_start=$(date +%s.%3N)
	reconstructPar 2>&1 | tee log.reconstructPar
	reconstructPar_end=$(date +%s.%3N)
	reconstructPar_elapsed=$(echo "scale=3; $reconstructPar_end - $reconstructPar_start" | bc)
	echo -e "reconstructPar \t" + $reconstructPar_elapsed >> log.timings
fi

