function mayaVI(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')
filename='/tmp/test.vtk';
execstr('exportVTK(filename,'+arg+')')
unix_g("mayavi -d "+filename+" -m Axes -m SurfaceMap &");  
endfunction









