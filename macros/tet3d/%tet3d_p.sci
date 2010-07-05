function %tet3d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Nom : '+string(th.Id));
  write(%io(2),'        '+string(size(th.Coor,1))+' points');
  write(%io(2),'        '+string(size(th.Tet,1))+' tetraedres');
  if th.Tri~=[]
    write(%io(2),'        '+string(size(th.Tri,1))+' triangles');
  end
   
endfunction

  
