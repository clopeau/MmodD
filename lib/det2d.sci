function Det=det2d(Coor,Tri)
  index=[2 3; 3 1; 1 2]';
  nt=size(Tri,1);
  Det=zeros(nt,1);
  tmp=zeros(nt,1);
  for i=1:3
      tmp=Coor(Tri(:,index(1,i)),2)- Coor(Tri(:,index(2,i)),2);
      Det=Det+Coor(Tri(:,i),1).*tmp;
  end
endfunction
