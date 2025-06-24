# shercliff_epotFoam

3D simulation of Shercliff flow using epotFoam.

epotFoam can be obtained from https://github.com/rweardley/epotFoam, based on [1]

Set up to run on 8 cores, takes around 20 seconds. Decomposition uses Scotch.

To run the case:

```
./shercliff.sh
```

To clean the case after running:

```
./Allclean
```

Try changing the resolution and/or mesh grading in ```system/blockMeshDict```:

```
blocks
(
    hex (0 1 2 3 4 5 6 7) (100 40 20)
    simpleGrading
    (1                      // x grading
    (                       // y grading
        (0.5 0.5 10)        // 50% of geometry, 50% of cells, expansion ratio 10
        (0.5 0.5 0.1)       // 50% of geometry, 50% of cells, expansion ratio 0.1
    )
    (                       // z grading
        (0.5 0.5 10)        // 50% of geometry, 50% of cells, expansion ratio 10
        (0.5 0.5 0.1)       // 50% of geometry, 50% of cells, expansion ratio 0.1
    ))
);
```

The resolution in this case is ```(100 40 20)``` for a total of 80k cells.
The mesh grading is set in the y and z directions to give cells in the centre 10x larger than those at the edges.

[1] Tassone, A.: Magnetic induction and electric potential solvers for incompressible MHD flows. In Proceedings of CFD with OpenSource Software, 2016, Edited by Nilsson H. http://dx.doi.org/10.17196/OS_CFD#YEAR_2016
