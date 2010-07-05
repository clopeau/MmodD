function th=%tri2d_a_s(th,s)
  dim=size(th.Coor,'c')
  np=size(th);
  
  if or(size(s)==[1,1])
    s=matrix(s,1,-1);
    sd=length(s);
    if sd==1
      th.Coor=th.Coor+s;
      return
    elseif sd==dim
      for i=1:sd
	th.Coor(:,i)=th.Coor(:,i)+s(i);
      end
    elseif dim==2 & sd==3
      th.Coor=[th.Coor zeros(np,1)]
      for i=1:sd
	th.Coor(:,i)=th.Coor(:,i)+s(i);
      end
      txt=getfield(1,th);
      txt(1)='tri3d';
      setfield(1,txt,th);
    else
      error('Bad dimension argument in %mesh_a_s');
    end
      
  else
    error('Bad dimension argument in %mesh_a_s');
  end
  
endfunction
