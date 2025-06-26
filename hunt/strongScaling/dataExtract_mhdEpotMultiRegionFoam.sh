#!/bin/bash

infile=$1

simutime_label_col=0
simutime_label="Time"
simutime_col=2

walltime_label_col=0
walltime_label="ExecutionTime"
walltime_col=2

printf "[0]SimTime,[1]ExecTime\n"

pRepeats=1
while read -r -a columns; do
	if [[ ${columns[simutime_label_col]} = $simutime_label ]]; then
    simTime="${columns[simutime_col]}"
	elif [[ ${columns[walltime_label_col]} = $walltime_label ]]; then
    walltime="${columns[walltime_col]}"
		printf "%s,%s\n" $simTime $walltime                
  fi
done <$infile
