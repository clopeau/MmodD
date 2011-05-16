function  Det=%tri3d_det(th)
  // Calcul du determinant des simplex 3d
  // Det=2|T| : |T| aire du triangle
  [n,nt]=size(th);
  lindex=list([1 2 3],[1 2 4],[1 3 4],[2 3 4]);
  // init espace
  p=th.Coor(th.Tri(:,2),:)-th.Coor(th.Tri(:,1),:); // vecteurs directeurs des cotes
  q=th.Coor(th.Tri(:,3),:)-th.Coor(th.Tri(:,1),:);
  NormT=p(:,[2 3 1]).*q(:,[3 1 2]) - p(:,[3 1 2]).*q(:,[2 3 1]);
  clear p q;
  Det=sqrt(sum(NormT.^2,'c'));
  
endfunction

