function paraview(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')

if ~MSDOS
  filename=TMPDIR+'/out.vtk';
  execstr('exportVTK(filename,'+arg+')')
  [rep,stat]=unix_g("paraview --data="+filename+" &");
  if stat<>0
    error("Paraview is not fund, install it or check your $PATH environnement variable.");
  end
else
  filename=TMPDIR+'\out.vtk';
  execstr('exportVTK(filename,'+arg+')')
  paraview_path=[];
  for Disk=['C','D','E','F','G','H','I','J'] //to much...
    Dirs=ls(Disk+":\Program Files\");
    if grep(Dirs,'ParaView')<>[]
      paraview_path=Disk+":\Program Files\"+Dirs(grep(Dirs,'ParaView'))+'\';
    end
  end
  if paraview_path==[]
    error("Paraview is not fund");
  else
    ActualDir=pwd();
    paraview_path=pathconvert(paraview_path);
    chdir(paraview_path+'\bin');
    [rep,stat]=unix_g("paraview.exe --data="+filename);
    if stat<>0
      error("Problem with ParaView");
    end
    chdir(ActualDir);
  end
end

     
endfunction









