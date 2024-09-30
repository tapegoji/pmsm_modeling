#!/bin/sh

# remove previous simulation results
rm -rf results_*

# run Elmer's simulation

if [ "$1" = "current" ]; then
    ElmerSolver current_stranded1.sif
    ElmerSolver current_stranded10.sif
    # plot scalar results
	if [ -d "results_stranded1" ] && [ -d "results_stranded10" ]; then
    		python3 plot_results_data.py current
	else
    		echo "Nothing to plot. One of the simulations failed"
		exit 1
	fi


elif [ "$1" = "voltage" ]; then
    ElmerSolver voltage_stranded1.sif
    ElmerSolver voltage_stranded10.sif

    # plot scalar results
    if [ -d "results_stranded1" ] && [ -d "results_stranded10" ]; then
    	python3 plot_results_data.py voltage
    else
        echo "Nothing to plot. One of the simulations failed"
        exit 1
    fi

else
    echo "Please, run ./run_simulation <source_type>"
    echo "where <source_type> is either 'current' or 'voltage'"
    exit 1
fi

