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
  list_open_file=file()
  ierr=execstr('u=mopen('''+filename+'.node'',''wt'')','errcatch')
  if ierr<>0
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       mclose(list_open_file)
     end
     error(str,n)
  end
  mfprintf(u,'%i 3 0 0\n',np);
  mfprintf(u,'%i %3.12f %3.12f %3.12f\n',(1:np)',th.Coor);
  mclose(u);
  
  // Face
  list_open_file=file()
  ierr=execstr('u=mopen('''+filename+'.face'',''wt'')','errcatch')
  if ierr<>0
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       mclose(list_open_file)
     end
     error(str,n)
  end
  
  ns=zeros(1,length(th.Face))
  for i=1:length(th.Face)
    ns(i)=length(th.Face(i));
  end
  mfprintf(u,'%i 1\n',nf);
  for i=1:length(th.Face)
    mfprintf(u,strcat(frmat(ones(1,ns(i)+2)),' ')+'\n',i,th.Face(i),th.Type(i));
  end
  mclose(u);
  
  // Cell
  list_open_file=file()
  ierr=execstr('u=mopen('''+filename+'.ele'',''wt'')','errcatch')
  if ierr<>0
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       mclose(list_open_file)
     end
     error(str,n)
  end
  ns=zeros(1,length(th.Cell))
  for i=1:length(th.Cell)
    ns(i)=length(th.Cell(i));
  end
  mfprintf(u,'%i 4 1\n',nc);
  for i=1:length(th.Cell)
     mfprintf(u,strcat(frmat(ones(1,ns(i)+2)),' ')+'\n',i,...
	abs(th.Cell(i)),th.Mat(i));
  end
 mclose(u)
  
else
 return
end
unix(%execu+'/tetview '+filename+'&');

endfunction

