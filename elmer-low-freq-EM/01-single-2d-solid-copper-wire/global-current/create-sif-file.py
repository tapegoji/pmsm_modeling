

# Define the list of files to be concatenated
files_to_concatenate = [
    "01-simulation-header/header-2d-transient.txt",
    "02-materials/materials.txt",
    # Uncomment the following line if you need to include this file in the future
    # "SINGLE-ROUND-WIRE/entities.sif",
    "03-domain-boundary-setup/domain-boundary-setup.txt",
    "04-solver-modules/solvers_2d_magnetodynamics_transient.txt"
]

# Output file
output_file = "main.sif"

# Open the output file in write mode to start fresh
with open(output_file, "w") as outfile:
    # Iterate over each file and append its content to the output file
    for file in files_to_concatenate:
        with open(file, "r") as infile:
            outfile.write(infile.read())
            outfile.write("\n")  # Add a newline between file contents

print(f"Files have been concatenated into {output_file}")

