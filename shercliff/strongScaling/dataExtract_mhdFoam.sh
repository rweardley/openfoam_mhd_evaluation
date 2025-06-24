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
solver_FiResid_col=11 # need to remove comma
solver_iters_col=14

smoothSolver_label="smoothSolver:"
DICPCG_label="DICPCG:"

smoothSolver_Ux_label="Ux,"
smoothSolver_Uy_label="Uy,"
smoothSolver_Uz_label="Uz,"

smoothSolver_Bx_label="Bx,"
smoothSolver_By_label="By,"
smoothSolver_Bz_label="Bz,"

DICPCG_p_label="p,"
DICPCG_pB_label="pB,"

divB_error_label_col=0
divB_error_label="magnetic"
divB_col=5

walltime_label_col=0
walltime_label="ExecutionTime"
walltime_col=2

printf "[0]SimTime,[1]CFLmean,[2]CFLmax,[3]UxResid,[4]UxIters,[5]UyResid,[6]UyIters,[7]UzResid,[8]UzIters,[9]BxResid_1,[10]BxIters_1,[11]BxResid_2,[12]BxIters_2,[13]BxResid_3,[14]BxIters_3,[15]ByResid_1,[16]ByIters_1,[17]ByResid_2,[18]ByIters_2,[19]ByResid_3,[20]ByIters_3,[21]BzResid_1,[22]BzIters_1,[23]BzResid_2,[24]BzIters_2,[25]BzResid_3,[26]BzIters_3,[27]pResid_1,[28]pIters_1,[29]pResid_2,[30]pIters_2,[31]pResid_3,[32]pIters_3,[33]pBResid_1,[34]pBIters_1,[35]pBResid_2,[36]pBIters_2,[37]pBResid_3,[38]pBIters_3,[39]divBerror,[40]ExecTime\n"

pRepeats=1
pBRepeats=1
BxRepeats=1
ByRepeats=1
BzRepeats=1
while read -r -a columns; do
        # [0] Simulation Time
	if [[ ${columns[simutime_label_col]} = $simutime_label ]]; then
                simTime="${columns[simutime_col]}"
	# CFL mean & max
	elif [[ ${columns[CFL_label_col]} = $CFL_label ]]; then
		CFL_mean="${columns[CFL_mean_col]}"
		CFL_max="${columns[CFL_max_col]}"
	# ssUx,y,z, Bx,y,z resid & iters
	# NOTE: just taking the final B values currently (does 3 correctors)
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
		elif [[ ${columns[solver_var_label_col]} = $smoothSolver_Bx_label ]]; then
                        if [[ $BxRepeats = 1 ]]; then
                                BxResid_1="${columns[solver_FiResid_col]}"
                                BxIters_1="${columns[solver_iters_col]}"
                                BxRepeats=2
                        elif [[ $BxRepeats = 2 ]]; then
                                BxResid_2="${columns[solver_FiResid_col]}"
                                BxIters_2="${columns[solver_iters_col]}"
                                BxRepeats=3
                        elif [[ $BxRepeats = 3 ]]; then
                                BxResid_3="${columns[solver_FiResid_col]}"
                                BxIters_3="${columns[solver_iters_col]}"
                                BxRepeats=1
                        fi
		elif [[ ${columns[solver_var_label_col]} = $smoothSolver_By_label ]]; then
                        if [[ $ByRepeats = 1 ]]; then
                                ByResid_1="${columns[solver_FiResid_col]}"
                                ByIters_1="${columns[solver_iters_col]}"
                                ByRepeats=2
                        elif [[ $ByRepeats = 2 ]]; then
                                ByResid_2="${columns[solver_FiResid_col]}"
                                ByIters_2="${columns[solver_iters_col]}"
                                ByRepeats=3
                        elif [[ $ByRepeats = 3 ]]; then
                                ByResid_3="${columns[solver_FiResid_col]}"
                                ByIters_3="${columns[solver_iters_col]}"
                                ByRepeats=1
                        fi
		elif [[ ${columns[solver_var_label_col]} = $smoothSolver_Bz_label ]]; then
                        if [[ $BzRepeats = 1 ]]; then
                                BzResid_1="${columns[solver_FiResid_col]}"
                                BzIters_1="${columns[solver_iters_col]}"
                                BzRepeats=2
                        elif [[ $BzRepeats = 2 ]]; then
                                BzResid_2="${columns[solver_FiResid_col]}"
                                BzIters_2="${columns[solver_iters_col]}"
                                BzRepeats=3
                        elif [[ $BzRepeats = 3 ]]; then
                                BzResid_3="${columns[solver_FiResid_col]}"
                                BzIters_3="${columns[solver_iters_col]}"
                                BzRepeats=1
                        fi
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
		elif [[ ${columns[solver_var_label_col]} = $DICPCG_pB_label ]]; then
                        if [[ $pBRepeats = 1 ]]; then
                                pBResid_1="${columns[solver_FiResid_col]}"
                                pBIters_1="${columns[solver_iters_col]}"
                                pBRepeats=2
                        elif [[ $pBRepeats = 2 ]]; then
                                pBResid_2="${columns[solver_FiResid_col]}"
                                pBIters_2="${columns[solver_iters_col]}"
                                pBRepeats=3
                        elif [[ $pBRepeats = 3 ]]; then
                                pBResid_3="${columns[solver_FiResid_col]}"
                                pBIters_3="${columns[solver_iters_col]}"
                                pBRepeats=1
                        fi
		fi
	# PotE resid & iters
	elif [[ ${columns[divB_error_label_col]} = $divB_error_label ]]; then
		divBerror="${columns[divB_col]}"

        # [1] Execution Time
	elif [[ ${columns[walltime_label_col]} = $walltime_label ]]; then
                walltime="${columns[walltime_col]}"
		printf "%s,%s,%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s%s,%s,%s\n" $simTime $CFL_mean $CFL_max $Ux_Resid $Ux_Iters $Uy_Resid $Uy_Iters $Uz_Resid $Uz_Iters $BxResid_1 $BxIters_1 $BxResid_2 $BxIters_2 $BxResid_3 $BxIters_3 $ByResid_1 $ByIters_1 $ByResid_2 $ByIters_2 $ByResid_3 $ByIters_3 $BzResid_1 $BzIters_1 $BzResid_2 $BzIters_2 $BzResid_3 $BzIters_3 $pResid_1 $pIters_1 $pResid_2 $pIters_2 $pResid_3 $pIters_3 $pBResid_1 $pBIters_1 $pBResid_2 $pBIters_2 $pBResid_3 $pBIters_3 $divBerror $walltime
        fi
done <$infile
