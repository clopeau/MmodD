function [out,bperio]=%tet3d_e(varargin)
   // fonction d'extration
   // syntaxe
   // th('S') renvoie les numeros de points frontiere

   // Extraction des connexions :
   // th(1,'c2n')
   
   [lhs,rhs]=argn(0);
   th=varargin($);
      
   if rhs==2
     bnd=matrix(varargin(1),1,-1);
     out=[];
     for bb=bnd
       id=find(th.BndId==bb)
       if id==[] 
	 warning(' Bad Boundary Name argument');
	 return
       end
       out=[out ;th.Bnd(id)]
     end

   elseif rhs==3
     [np,nt]=size(th)
     if varargin(2)=='c2n'
       out=matrix(th.Tri(:,varargin(1)),nt,-1)
     elseif varargin(2)=='c2f'
       error('Extraction de tet3d : option non implemente')
     end
   else
     error('Extraction de tet3d : option non reconnue')
   end
 
endfunction  

