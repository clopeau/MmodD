function paraview(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')
//-------------------------------------
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









