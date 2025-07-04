#!/bin/bash

infile=$1

simutime_label_col=0
simutime_label="Time"
simutime_col=2

CFL_label_col=0
CFL_label="Courant"
CFL_mean_col=3
CFL_max_col=5

solver_label_col=0
solver_var_label_col=3
solver_FiResid_col=11
solver_iters_col=14

smoothSolver_label="smoothSolver:"
DICPCG_label="DICPCG:"

smoothSolver_Ux_label="Ux,"
smoothSolver_Uy_label="Uy,"
smoothSolver_Uz_label="Uz,"

DICPCG_p_label="p,"
DICPCG_PotE_label="PotE,"

walltime_label_col=0
walltime_label="ExecutionTime"
walltime_col=2

printf "[0]SimTime,[1]CFLmean,[2]CFLmax,[3]UxResid,[4]UxIters,[5]UyResid,[6]UyIters,[7]UzResid,[8]UzIters,[9]pResid_1,[10]pIters_1,[11]pResid_2,[12]pIters_2,[13]pResid_3,[14]pIters_3,[15]PotEResid,[16]PotEIters,[17]ExecTime\n"

pRepeats=1
while read -r -a columns; do
        # [0] Simulation Time
	if [[ ${columns[simutime_label_col]} = $simutime_label ]]; then
                simTime="${columns[simutime_col]}"
	# CFL mean & max
	elif [[ ${columns[CFL_label_col]} = $CFL_label ]]; then
		CFL_mean="${columns[CFL_mean_col]}"
		CFL_max="${columns[CFL_max_col]}"
	# ssUx,y,z, Bx,y,z resid & iters
	elif [[ ${columns[solver_label_col]} = $smoothSolver_label ]]; then
		if [[ ${columns[solver_var_label_col]} = $smoothSolver_Ux_label ]]; then
			Ux_Resid="${columns[solver_FiResid_col]}"
			Ux_Iters="${columns[solver_iters_col]}"
		elif [[ ${columns[solver_var_label_col]} = $smoothSolver_Uy_label ]]; then
			Uy_Resid="${columns[solver_FiResid_col]}"
			Uy_Iters="${columns[solver_iters_col]}"
		elif [[ ${columns[solver_var_label_col]} = $smoothSolver_Uz_label ]]; then
			Uz_Resid="${columns[solver_FiResid_col]}"
			Uz_Iters="${columns[solver_iters_col]}"
		fi
	elif [[ ${columns[solver_label_col]} = $DICPCG_label ]]; then
		if [[ ${columns[solver_var_label_col]} = $DICPCG_p_label ]]; then
			if [[ $pRepeats = 1 ]]; then
				pResid_1="${columns[solver_FiResid_col]}"
				pIters_1="${columns[solver_iters_col]}"
				pRepeats=2
			elif [[ $pRepeats = 2 ]]; then
				pResid_2="${columns[solver_FiResid_col]}"
				pIters_2="${columns[solver_iters_col]}"
				pRepeats=3
			elif [[ $pRepeats = 3 ]]; then
				pResid_3="${columns[solver_FiResid_col]}"
				pIters_3="${columns[solver_iters_col]}"
				pRepeats=1
			fi
		elif [[ ${columns[solver_var_label_col]} = $DICPCG_PotE_label ]]; then
			PotE_Resid="${columns[solver_FiResid_col]}"
			PotE_Iters="${columns[solver_iters_col]}"
		fi
	elif [[ ${columns[walltime_label_col]} = $walltime_label ]]; then
                walltime="${columns[walltime_col]}"
                printf "%s,%s,%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s\n" $simTime $CFL_mean $CFL_max $Ux_Resid $Ux_Iters $Uy_Resid $Uy_Iters $Uz_Resid $Uz_Iters $pResid_1 $pIters_1 $pResid_2 $pIters_2 $pResid_3 $pIters_3 $PotE_Resid $PotE_Iters $walltime
        fi
done <$infile
