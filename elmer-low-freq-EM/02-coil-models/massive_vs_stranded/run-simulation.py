import os
import shutil
import subprocess
import sys

# Function to remove previous simulation results
def remove_previous_results():
    for item in os.listdir():
        if item.startswith("results_"):
            if os.path.isdir(item):
                shutil.rmtree(item)

# Function to run ElmerSolver and plot results
def run_simulation(source_type):
    if source_type == "current":
        # Run Elmer simulations
        subprocess.run(["ElmerSolver", "current_massive.sif"], check=True)
        subprocess.run(["ElmerSolver", "current_stranded.sif"], check=True)
        
        # Check if simulation results exist, then plot
        if os.path.isdir("results_stranded") and os.path.isdir("results_massive"):
            subprocess.run(["python3", "plot_results_data.py", "current"], check=True)
        else:
            print("Nothing to plot. One of the simulations failed")
            sys.exit(1)

    elif source_type == "voltage":
        # Run Elmer simulations
        subprocess.run(["ElmerSolver", "voltage_massive.sif"], check=True)
        subprocess.run(["ElmerSolver", "voltage_stranded.sif"], check=True)

        # Check if simulation results exist, then plot
        if os.path.isdir("results_stranded") and os.path.isdir("results_massive"):
            subprocess.run(["python3", "plot_results_data.py", "voltage"], check=True)
        else:
            print("Nothing to plot. One of the simulations failed")
            sys.exit(1)
    
    else:
        print("Please, run the script as:")
        print("python3 run_simulation.py <source_type>")
        print("where <source_type> is either 'current' or 'voltage'")
        sys.exit(1)

if __name__ == "__main__":
    # Ensure a source type argument is provided
    if len(sys.argv) != 2:
        print("Usage: python3 run_simulation.py <source_type>")
        sys.exit(1)

    source_type = sys.argv[1]

    # Remove previous results and run the simulation
    remove_previous_results()
    run_simulation(source_type)

