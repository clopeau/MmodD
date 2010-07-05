function []=tri2d_show_bnd(th,coul)
// fonction d'affichage des frontieres
// th : mesh
// cool : couleur associe
   [lhs,rhs]=argn(0);
   if rhs==1 
     nbnd=length(th.Bnd);
     coul=3:2+nbnd;
     if nbnd>5
       coul(6)=1;
     end
   elseif rhs==2
     nbnd=length(coul);
   end

   xset("thickness",2) 
   for i=1:nbnd
     xy=th.Coor(th.Bnd(i),:);
     xsegs([xy(1:$-1,1) xy(2:$,1)]',...
	 [xy(1:$-1,2) xy(2:$,2)]',coul(i));
   end
   legends(matrix(th.BndId,-1,1),coul,opt=1)
   xset("thickness",1) 
endfunction
