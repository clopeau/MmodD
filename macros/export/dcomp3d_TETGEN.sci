// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function dcomp3d_TETGEN(filename,th)


[np,nf,nc]=size(th);
frmat="%i";
// Coor
u=mopen(filename+'.node','wt')
mfprintf(u,'%i 3 0 0\n',np);
mfprintf(u,'%i %3.12f %3.12f %3.12f\n',(1:np)',th.Coor);
mclose(u);

// Face
u=mopen(filename+'.face','wt')
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
u=mopen(filename+'.ele','wt')
ns=zeros(1,length(th.Cell))
for i=1:length(th.Cell)
  ns(i)=length(th.Cell(i));
end
mfprintf(u,'%i 4 1\n',nc);
for i=1:length(th.Cell)
  mfprintf(u,strcat(frmat(ones(1,ns(i)+2)),' ')+'\n',i,...
      abs(th.Cell(i)),th.Mat(i));
end
mclose(u);


endfunction

