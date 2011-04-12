// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tetview(th)
[lhs,rhs]=argn(0);
filename='/tmp/tetview_'+getenv('LOGNAME')';
if typeof(th)=='tet3d'
  execstr('exportTETGEN(filename,th)')
elseif  typeof(th)=="dcomp3d"
  [np,nf,nc]=size(th);
  frmat="%i";
  // Coor
  u=file('open',filename+'.node','unknown')
  fprintf(u,'%i 3 0 0',np);
  fprintf(u,'%i %3.12f %3.12f %3.12f\n',(1:np)',th.Coor);
  file('close',u);
  
  // Face
  u=file('open',filename+'.face','unknown')
  ns=zeros(1,length(th.Face))
  for i=1:length(th.Face)
    ns(i)=length(th.Face(i));
  end
  fprintf(u,'%i 1',nf);
  for i=1:length(th.Face)
    fprintf(u,strcat(frmat(ones(1,ns(i)+2)),' ')+'\n',i,th.Face(i),th.Type(i));
  end
  file('close',u);
  
  // Cell
  u=file('open',filename+'.ele','unknown')
  ns=zeros(1,length(th.Cell))
  for i=1:length(th.Cell)
    ns(i)=length(th.Cell(i));
  end
  fprintf(u,'%i 4 1',nc);
  for i=1:length(th.Cell)
     fprintf(u,strcat(frmat(ones(1,ns(i)+2)),' ')+'\n',i,...
	abs(th.Cell(i)),th.Mat(i));
  end
  file('close',u);
  
else
 return
end
unix(%execu+'/tetview '+filename+'&');

endfunction

