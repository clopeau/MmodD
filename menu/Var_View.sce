// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

%_nams=who('get');
%ind=evstr('type('+%_nams+')');
%_nams=%_nams(%ind==17);
%geom_c=['p1_1d' 'p1_2d' 'p1_3d' 'q1_2d' 'p0_1d' 'p0_2d'];
if %_nams~=[]
  %_nams=%_nams(grep(evstr('typeof('+%_nams+')'),%geom_c));
end
if %_nams~=[]
  %n=size(%_nams,'*');
  if %n>1
    %n=x_choose(%_nams+'  ('+evstr('typeof('+%_nams+')')+')',...
	'Choose a mesh','Cancel');
  end
  global %mmodd_path
  exec(%mmodd_path+"/menu/Var_Tool.sce");
  clear %n  
else 
  disp('------- No Variables  -------')
end

clear %_nams %ind %geom_c
