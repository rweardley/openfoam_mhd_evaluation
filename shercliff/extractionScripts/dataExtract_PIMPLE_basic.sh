#!/bin/bash

infile=$1

simutime_label_col=0
simutime_label="Time"
simutime_col=2

CFL_label_col=0
CFL_label="Courant"
CFL_mean_col=3
CFL_max_col=5

PIMPLE_iters_label_col=0
PIMPLE_iters_label="PIMPLE:"
PIMPLE_iters_condition_label_col=1
PIMPLE_iters_condition_label="iteration"
PIMPLE_iters_col=2

walltime_label_col=0
walltime_label="ExecutionTime"
walltime_col=2

printf "[0]SimulationTime,[1]CFLmean,[2]CFLmax,[3]PIMPLEiters,[4]WallTime\n"


while read -ra columns; do
    # [0] Simulation time
    if [[ ${columns[simutime_label_col]} = $simutime_label ]]; then
        simTime="${columns[simutime_col]}"
    # CFL [1] mean & [2] max
    elif [[ ${columns[CFL_label_col]} = $CFL_label ]]; then
        CFL_mean="${columns[CFL_mean_col]}"
        CFL_max="${columns[CFL_max_col]}"
    # [3] PIMPLE Iterations (count, overwritten each PIMPLE iteration until printed at end of timestep)
    elif [[ ${columns[PIMPLE_iters_label_col]} = $PIMPLE_iters_label ]]; then
        if [[ ${columns[PIMPLE_iters_condition_label_col]} = $PIMPLE_iters_condition_label ]]; then
            PIMPLE_iters="${columns[PIMPLE_iters_col]}"
	fi
    # [4] Walltime
    elif [[ ${columns[walltime_label_col]} = $walltime_label ]]; then
        walltime="${columns[walltime_col]}"
        printf "%s,%s,%s,%s,%s\n" $simTime $CFL_mean $CFL_max $PIMPLE_iters $walltime
    fi
done <$infile

