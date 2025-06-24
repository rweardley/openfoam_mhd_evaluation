#!/bin/bash

source ~/.openfoam10_profile

cores=76

blockMesh 2>&1 | tee log.blockMesh

if [[ ! $cores -eq 1 ]]
then
	decomposePar 2>&1 | tee log.decomposePar
	orterun -np $cores mhdFoam -parallel 2>&1 | tee log.mhdFoam
	reconstructPar 2>&1 | tee log.reconstructPar
else
	epotFoam 2>&1 | tee log.mhdFoam
fi
