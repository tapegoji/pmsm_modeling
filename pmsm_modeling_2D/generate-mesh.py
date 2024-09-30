#
# generate-mesh.ph: 
# Create Elmer Mesh (PMSM_2POLE) from a GMSH geo/mesh stator/rotor_pmsm_2p_2D.geo
# Description: Generate Stator and Rotor mesh separately
#              to keep clean mortor boundary and 
#              unite them both into a single mesh PMSM_2POLE
# Author: Jonathan Velasco
#--------------------------------------------------------------------------------------

import subprocess

def run_command(command):
    """Run a shell command and print its output."""
    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error running command {e.cmd}: {e.stderr}")

# Create gmsh mesh
run_command(['gmsh', 'mesh/stator_pmsm_2p_2D.geo', '-2', '-o', 'mesh/pmsm_stator.msh'])
run_command(['gmsh', 'mesh/rotor_pmsm_2p_2D.geo', '-2', '-o', 'mesh/pmsm_rotor.msh'])

# Create elmer mesh from gmsh .msh

# Create rotor mesh
run_command(['ElmerGrid', '14', '2', 'mesh/pmsm_rotor.msh', '-2d', '--autoclean', '--names', '-out', 'PMSM_ROTOR'])

# Create stator mesh
run_command(['ElmerGrid', '14', '2', 'mesh/pmsm_stator.msh', '-2d', '--autoclean', '--names', '-out', 'PMSM_STATOR'])

# Create union mesh: stator + rotor
run_command(['ElmerGrid', '2', '2', 'PMSM_STATOR', '-in', 'PMSM_ROTOR', '-unite', '--autoclean', '--names', '-out', 'PMSM_2POLE'])

