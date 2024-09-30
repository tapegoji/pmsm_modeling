# Current density vs. Global Current

This example models a single round copper wire, excited by a 1A DC current source. The wire is modeled as a 2D solid conductor and the simulation is transient.


- These two examples are in their respective directories
- The objectives is to show two alternative ways to set up a current source in the case of a current carrying conductor
- The Current Density example uses an external current source as a Body Force term
- The Global Current implements a current source using circuit equations and a massive coil model
- The models run using shell script run-simulation.sh or python script run-simulation.py
- The run-simulation scripts call other scripts to perform the following operations:
    - Create Elmer's mesh from Gmsh's mesh (generate-mesh.py)
    - Generate's a the .sif file from 4 different sources just to showcase my preferred way to set up transient Magnetodynamics problems in 2D
    - Lastly, it runs the model in series using 

```bash
ElmerSolver main.sif
```

