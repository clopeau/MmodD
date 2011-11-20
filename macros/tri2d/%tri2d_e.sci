// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out,bperio]=%tri2d_e(varargin)
   // fonction d'extration
   // syntaxe
   // th('S') renvoie les numeros de points frontiere

   // Extraction des connexions :
   // th(1,'c2n')
   
   [lhs,rhs]=argn(0);
   //th=varargin($);
      
   if rhs==2
     bnd=matrix(varargin(1),1,-1);
     out=[];
     for bb=bnd
       id=find(varargin($).BndId==bb)
       if id==[] 
	 error('Bad Boundary Name argument');  
       end
       if out($)==varargin($).Bnd(id)(1)
	 out=[out ;matrix(varargin($).Bnd(id)(2:$),-1,1)]
       else      
	 out=[out ;matrix(varargin($).Bnd(id),-1,1)]
       end
     end
     if out(1)==out($)
       out($)=[]
     end
     xx=out

   elseif rhs==3
     [np,nt]=size(varargin($))
     if varargin(2)=='c2n'
       out=matrix(varargin($).Tri(:,varargin(1)),nt,-1)
     elseif varargin(2)=='c2f'
       error('Extraction de tri2d : option non implemente')
     end
   else
     error('Extraction de tri2d : option non reconnue')
   end
 
endfunction  

