import subprocess

def run_elmer_solver():
    try:
        # Run ElmerSolver without capturing output, letting it stream to console directly
        subprocess.run(["ElmerSolver", "voltage_stranded.sif"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error while running ElmerSolver: {e}")

if __name__ == "__main__":
    run_elmer_solver()

