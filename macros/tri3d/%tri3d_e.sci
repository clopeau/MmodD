function [out,bperio]=%tri3d_e(varargin)
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
	 error('Bad Boundary Name argument');  
       end
       if out($)==th.Bnd(id)(1)
	 out=[out ;matrix(th.Bnd(id)(2:$),-1,1)]
       else      
	 out=[out ;matrix(th.Bnd(id),-1,1)]
       end
     end
     if out(1)==out($)
       out($)=[]
     end
     xx=out

   elseif rhs==3
     [np,nt]=size(th)
     if varargin(2)=='c2n'
       out=matrix(th.Tri(:,varargin(1)),nt,-1)
     elseif varargin(2)=='c2f'
       error('Extraction de tri3d : option non implemente')
     end
   else
     error('Extraction de tri3d : option non reconnue')
   end
 
endfunction  

