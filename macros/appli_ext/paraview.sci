function paraview(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')
//-------------------------------------

//--- Adding  domain identitity for single mesh call
if rhs==1
  if typeof(varargin(1))=='tri2d'
    %Domain=p0(varargin(1))
    %Domain.Id='Domain'
    %Domain.Cell=varargin(1).TriId
    arg=arg+",%Domain"
  elseif typeof(varargin(1))=='tet3d'
    %Domain=p0(varargin(1))
    %Domain.Id='Domain'
    %Domain.Cell=varargin(1).TetId
    arg=arg+",%Domain"
  end
end

//----------------------------------------------
global %paraview_path;
if %paraview_path==[]
  error("Paraview is not fund, install it or check your $PATH environnement variable.");
end

if ~MSDOS
  // MacOS and Linux
  filename=TMPDIR+'/out.vtk';
  execstr('exportVTK(filename,'+arg+')')
  [rep,stat]=unix_g(%paraview_path+'/'+"paraview --data="+filename+" &");
  if stat<>0
    error("Paraview is not fund, install it or check your $PATH environnement variable.");
  end
else
  // on Windows
  filename=TMPDIR+'\out.vtk';
  execstr('exportVTK(filename,'+arg+')')
  [rep,stat]=unix_g(pathconvert(paraview_path)+'\'+"paraview.exe --data="+filename+" &");
  if stat<>0
    error("Problem with ParaView");
  end
end
     
endfunction









