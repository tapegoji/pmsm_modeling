#
# run-simulation.py
# Description: Checks if an Elmer mesh is available, if not, creates one 
#              using a generate-mesh.py script. In both cases it runs the
#              Elmer simulation given .sif file and command
#              This script only runs serial simulations. For pararell case,
#              edit both this and the meshing script.
# Author: Jonathan Velasco
#--------------------------------------------------------------------------------------
import os
import subprocess

mesh_directory = 'SINGLE-ROUND-WIRE'
mesh_script = 'generate-mesh.py'
sif_file = 'main.sif'
sif_script = 'create-sif-file.py'
elmer_solver_command = 'ElmerSolver'

# ---------------------------- Do not edit below this line ----------------------------

def run_command(command):
    """Run a shell command and print its output."""
    try:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        for line in process.stdout:
            print(line, end='')  # Print stdout in real-time
        stderr = process.stderr.read()  # Read stderr after stdout to ensure all output is captured
        if stderr:
            print(stderr, end='')  # Print stderr
        process.wait()  # Wait for the process to complete
    except subprocess.CalledProcessError as e:
        print(f"Error running command {e.cmd}: {e.stderr}")

def main():

    if not os.path.exists(mesh_directory):
        print(f"{mesh_directory} not found. Running {mesh_script} to generate the mesh.")
        run_command(['python3', mesh_script])
    if not os.path.exists(sif_file):
        print(f"{sif_file} not found. Running {sif_script} to generate the .sif file.")
        run_command(['python3', sif_script])
    print(f"{mesh_directory} found. Running ElmerSolver with {sif_file}.")
    run_command([elmer_solver_command, sif_file])

if __name__ == '__main__':
    main()

