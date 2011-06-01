// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

%_nams=who('get');
%ind=evstr('type('+%_nams+')');
%_nams=%_nams(%ind==17);
%geom_c=['grid2d' 'grid3d' 'tri2d' 'quad2d' 'tet3d' 'hex3d'];
if %_nams~=[]
  %_nams=%_nams(grep(evstr('typeof('+%_nams+')'),%geom_c));
end
if %_nams~=[]
  %n=size(%_nams,'*');
  if %n>1
    %n=x_choose(%_nams+'  ('+evstr('typeof('+%_nams+')')+')',...
	'Choose a mesh','Cancel');
end
 //mesh_tool(%n)
 global %mmodd_path
 exec(%mmodd_path+"/menu/Mesh_Tool.sce");
  clear %n
  disp('')
else  
  disp('------- No mesh  -------')
end

clear %_nams %ind %geom_c

