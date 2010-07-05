function []=grid2d_show_bnd(g,coul)
// fonction d'affichage des frontieres
// g : grid2d
// cool : couleur associe
   [lhs,rhs]=argn(0);
   if rhs==1 
     nbnd=4
     coul=4:3+nbnd;
   elseif rhs==2
     nbnd=length(coul);
   end

   Name=['S','E','N','W']
   X=g.x([1,$,$,1])';
   Y=g.y([1,1,$,$])';
   xsegs([X; [X(2:$),X(1)]],...
	 [Y; [Y(2:$),Y(1)]],coul);
      
   legends(matrix(Name,-1,1),coul,1)
endfunction
