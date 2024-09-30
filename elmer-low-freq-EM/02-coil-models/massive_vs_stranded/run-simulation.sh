#!/bin/sh

# remove previous simulation results
rm -rf results_*

# run Elmer's simulation

if [ "$1" = "current" ]; then
    ElmerSolver current_massive.sif
    ElmerSolver current_stranded.sif
    # plot scalar results
	if [ -d "results_stranded" ] && [ -d "results_massive" ]; then
    		python3 plot_results_data.py current
	else
    		echo "Nothing to plot. One of the simulations failed"
		exit 1
	fi


elif [ "$1" = "voltage" ]; then
    ElmerSolver voltage_massive.sif
    ElmerSolver voltage_stranded.sif

    # plot scalar results
    if [ -d "results_stranded" ] && [ -d "results_massive" ]; then
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

