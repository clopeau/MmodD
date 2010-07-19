Mesh quality output file: ./ex.qual
Reading 2D boundary geometry file ./ex.bdry
Reading patch #0
Reading patch #4
Reading patch #5
Going through patches to determine original discretization...      0 swaps
done.
Now trying to recover all of the edges... Looking at edge 0 -- (1.000000, 0.500000)->(1.000000, 1.000000) -- Patch #0
Edge 0 was present.
Looking at edge 1 -- (1.000000, 1.000000)->(-0.200000, 1.000000) -- Patch #1
Edge 1 was present.
Looking at edge 2 -- (-0.200000, 1.000000)->(-0.200000, 0.000000) -- Patch #2
Edge 2 was present.
Looking at edge 3 -- (-0.200000, 0.000000)->(0.500000, 0.000000) -- Patch #3
Edge 3 was present.
Looking at edge 4 -- (0.950000, 0.500000)->(0.725000, 0.889711) -- Patch #4
Edge 4 was present.
Looking at edge 5 -- (0.725000, 0.889711)->(0.275000, 0.889711) -- Patch #4
Edge 5 was present.
Looking at edge 6 -- (0.275000, 0.889711)->(0.050000, 0.500000) -- Patch #4
Edge 6 was present.
Looking at edge 7 -- (0.050000, 0.500000)->(0.275000, 0.110289) -- Patch #4
Edge 7 was present.
Looking at edge 8 -- (0.275000, 0.110289)->(0.725000, 0.110289) -- Patch #4
Edge 8 was present.
Looking at edge 9 -- (0.725000, 0.110289)->(0.950000, 0.500000) -- Patch #4
Edge 9 was present.
Looking at edge 10 -- (0.500000, 0.000000)->(0.692913, 0.059235) -- Patch #5
Edge 10 was present.
Looking at edge 11 -- (0.692913, 0.059235)->(0.940765, 0.307087) -- Patch #5
Edge 11 was present.
Looking at edge 12 -- (0.940765, 0.307087)->(1.000000, 0.500000) -- Patch #5
Edge 12 was present.
Looping back; 13 edges present
done.
Now deleting unnecessary cells and faces... done.
 Swapping to make sure everything is Delaunay...
     0 swaps
done; 0 swaps.
Number of points in bdry file: 8
Number of verts in initial triangulation:  13
Number of triangles in initial triangulation:  13
Evaluating quality of volume mesh...done.
Looking for small angles in the geometry
Done looking for small angles
Checking for large angles..
EVEN NEWER METHOD: Point is located outside
Attempting insertion to fix exterior bug at (0.889711, 0.275000)
And trying to insert at (0.832500, 0.167500) again...
Done checking for large angles
Setting up initial geometric length scale for mesh...
Updating length scale to take grading into account...
Done with grading check.
Done with length scale initialization.
Initializing insertion priority queue...
Worst allowed cell shape measure is 0.500000.
Queueing simplex cells that don't meet quality criterion...queued 54.
Initial insertion queue length is 54.
Refining mesh to reach quality target...
Number of triangles after initial refinement:  206
Initializing insertion priority queue...
Worst allowed cell shape measure is 0.500000.
Queueing simplex cells that don't meet quality criterion...queued 0.
Initial insertion queue length is 0.
Number of triangles after initial refinement:  206
Evaluating quality of volume mesh...done.
Number of triangles after refinement:  206
Writing mesh to file(s)...
Renumbering vertices...done.
Renumbering cells...done.
Renumbering faces...done.
Opening boundary patch output file ./ex.bpatch
Done

Executable tri (linked to GRUMMP version 0.5.0) exiting successfully.

