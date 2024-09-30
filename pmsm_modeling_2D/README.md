# Permanent Magnet Sychronous Machine - 2 Pole

This is a simple demo to showcase how to set up a 3 phase voltage source using the circuit builder, in addition to set up permanent magnets in an Elmer simulation

## How to run

```bash
python3 run-simulation.py
```

- The script wil check if the mesh has been generated, if not it will create it from GMSH's .geo files find under mesh/ and run the simulation

- I've added a plot script for quick visualization of circuit information

```bash
python3 plot-results-data.py
```

- This interactive script displays all available options and let's you select via command line what the x-axis and y-axis are to be populated with

- The VTU file for postprocessing with paraview can be found under the results directory res/
