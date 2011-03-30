function paraview(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')
filename='/tmp/test_'+getenv('LOGNAME')+'.vtk';
execstr('exportVTK(filename,'+arg+')')
// change paraview 2.2
//unix_g("paraview -b "+%path_femt+"/lib/visualisation/para.pvs &");  
unix_g("paraview --data="+filename+" &");  
endfunction









