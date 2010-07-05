function []=tet3d_plot(th,col)
// Mesh visualisation 
  [lhs,rhs]=argn(0);
//  if rhs==1 
//    coul=1
//  end
  n=size(th);
  index=[1 2; 2 3; 3 1]'
  
  x=[];y=[];z=[];colori=[];
  for i=1:length(th.Bnd)
    ed=gsort(th.Bnd(i),'c','i');
    p=size(ed,1);
    spEdge=sparse([1 1],%f,[n,n]);
    for j=index
      spEdge=spEdge | sparse(ed(:,j),~zeros(p,1),[n,n]);
    end
    ed=spget(spEdge);
    p=size(ed,1);
    x=[x,matrix(th.Coor(ed,1),-1,2)'];
    y=[y,matrix(th.Coor(ed,2),-1,2)'];
    z=[z,matrix(th.Coor(ed,3),-1,2)'];
    colori=[colori,i(ones(1,p))];
  end

  param3d1(x,y,list(z,colori),flag=[2,4]);
  legends(th.BndId,1:length(th.Bnd),4)

endfunction
