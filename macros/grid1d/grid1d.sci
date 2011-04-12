// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=grid1d(x) 
// construction d'une grille reguliere
// x,y  tableaux de points (ordre croissants)
// ou
// x,y nombres de points en x,y

  [lhs,rhs]=argn(0);
  // extraction de la grille frontière
  if typeof(x)=='grid1d'
    out=export_grid1d(x,y)
    return
  end
  
  // unite par defaut
  if rhs==0
    x=10
  end
  if length(x)==1
    x=linspace(0,1,x)';
  end
  
  // suivant nombre d'argument et mise en colonne
  x=matrix(x,-1,1);
  id='grid1d'
  BndId=['E','W'];
  Bnd=list(1,length(x))
  out=mlist(['grid1d';'#';'id';'BndId';'Bnd';'x'],rand(),id,BndId,Bnd,x)
    
endfunction

