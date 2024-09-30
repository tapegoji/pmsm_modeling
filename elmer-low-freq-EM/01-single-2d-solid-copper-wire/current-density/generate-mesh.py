#
# generate-mesh.ph: 
# Create Elmer Mesh from a GMSH geo file
#--------------------------------------------------------------------------------------

import subprocess

gmsh_directory = "gmsh/"
gmsh_project_name = "single-round-wire"
# -------------------------------- Do not edit under this line ------------------------

gmsh_geo = gmsh_directory + gmsh_project_name + '.geo'
gmsh_msh = gmsh_directory + gmsh_project_name + '.msh'
elmer_mesh_name = gmsh_project_name.upper()

def run_command(command):
    """Run a shell command and print its output."""
    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error running command {e.cmd}: {e.stderr}")

# Create gmsh mesh
run_command(['gmsh', gmsh_geo, '-2', '-o', gmsh_msh])

# Create elmer mesh from gmsh .msh
# Create rotor mesh
run_command(['ElmerGrid', '14', '2', gmsh_msh, '-2d', '--autoclean', '--names', '-out', elmer_mesh_name])


