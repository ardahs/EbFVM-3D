# 3-D Element-based Finite Volume Method (EbFVM) for Interfacial Transport Dynamics

## Overview

This repository contains the MATLAB implementation of a three-dimensional Element-based Finite Volume Method (EbFVM) for the simulation of interfacial transport problems on unstructured meshes.
The framework is developed for the modelling of heterogeneous interfaces and is particularly well suited to coupled transport problems in complex domains.
In its current form, the code is configured for lubrication simulations in misaligned journal bearings, with support for both 2D isothermal and 3D thermal analyses.

This code is associated with the paper:

**Modelling Heterogeneous Interfaces using Element-based Finite Volumes**

by Suhaib Ardah, Francisco J. Profito and Daniele Dini <br>
Computer Methods in Applied Mechanics and Engineering (2026)
[https://doi.org/10.1016/j.cma.2026.118986]

It includes the core solver, benchmark cases, and reference material required to reproduce the results reported in the manuscript and to extend the framework to new geometries and applications.

## Contact

For questions, suggestions, or collaboration opportunities, please contact:

**Suhaib Ardah**  
s.ardah19@imperial.ac.uk

## Related publications

For theoretical background and formulation details, see:

- **Modelling Heterogeneous Interfaces using Element-based Finite Volumes**
  Suhaib Ardah, Francisco J. Profito and Daniele Dini (2026).
  [https://doi.org/10.1016/j.cma.2026.118986]
  Main reference for the present 3D implementation.

- **Advanced Modelling of Lubricated Interfaces in General Curvilinear Grids**
  Suhaib Ardah, Francisco J. Profito, Tom Reddyhoff and Daniele Dini (2023).
  [https://doi.org/10.1016/j.triboint.2023.108727] 
  Further details on the governing equations in curvilinear coordinates.

## External mesh data

Due to GitHub file-size limitations, the full mesh files are hosted separately on Zenodo. These files are required to reproduce the benchmark results reported in the manuscript.

**[https://doi.org/10.5281/zenodo.19432407]**  

Please download the dataset and place the mesh files in your local working directory before running the full cases.

## Repository structure

- `src/`     — Core solver and numerical routines  
- `cases/`   — Benchmark and manuscript test cases  
- `figures/` — Manuscript figures 

## Requirements

- MATLAB  
- Optional: MEX compilation for improved performance

## Quick start

1. Download the required mesh files from Zenodo and place them in the appropriate local directory.
2. Set the geometry, analysis type, and convergence tolerance in `main.m`
3. Run `main.m`

## Options

**Geometry**
- `Dimple`
- `Herringbone`
- `SawTooth`

**Analysis**
- `Isothermal`
- `Thermal`

**Tolerance error**  
`toleranceError` controls only the convergence criterion of the coupled iterative procedure. It does not affect the EbFVM discretisation itself.

## Runtime and reproducibility

For faster runs:
- use `analysisType = 'Isothermal'
- use a larger `toleranceError`

To reproduce the paper results:
- use `analysisType   = 'Thermal'
- use `toleranceError = 1e-3`

## Mesh generation and geometry input

The repository includes predefined geometries for the manuscript cases. However, users may also use the code with other geometries by generating and importing the required mesh data.

Custom meshes can be generated using standard mesh generation and preprocessing software such as:
	•	Abaqus
	•	Gmsh
	•	ANSYS Meshing
	•	other equivalent software

Required mesh information:
To use a custom geometry, the mesh input must provide the information required by the EbFVM data structures, including:
	•	nodal coordinates
	•	element connectivity
	•	surrounding-node information
	•	surrounding-element information
	•	boundary-condition information associated with nodes and boundary edges

## Steady-state formulation and transient extensions

The present implementation is formulated for steady-state problems.

However, transient effects can be incorporated in a relatively straightforward manner through the existing source-term structures. In particular:
	•	transient contributions in the thermal energy equation can be introduced in 'EnergyFluid.m' through: gridCFDNodes_3D.sTS
	•	transient contributions in the generalised Reynolds equation can be introduced in 'GRE_lubricantTransport.m' through: gridCFDNodes.sT

## Performance optimisation

For improved runtime performance, the 'sorSolver_FVMbE_JFO' routine may be converted to MEX function to accelerate execution.
https://uk.mathworks.com/help/matlab/ref/mex.html
