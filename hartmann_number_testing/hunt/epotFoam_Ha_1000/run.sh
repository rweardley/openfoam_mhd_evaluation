#!/bin/bash

cores=76

source ~/.openfoam10_profile

blockMesh 2>&1 | tee log.blockMesh

if [[ ! $cores -eq 1 ]]
then
	decomposePar 2>&1 | tee log.decomposePar
	mpirun -np $cores epotFoam -parallel 2>&1 | tee log.epotFoam
	reconstructPar 2>&1 | tee log.reconstructPar
else
	epotFoam 2>&1 | tee log.epotFoam
fi
