// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out,bperio]=%tet3d_e(varargin)
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
	 warning(' Bad Boundary Name argument');
	 return
       end
       out=[out ;varargin($).Bnd(id)]
     end

   elseif rhs==3
     [np,nt]=size(varargin($))
     if varargin(2)=='c2n'
       out=matrix(varargin($).Tri(:,varargin(1)),nt,-1)
     elseif varargin(2)=='c2f'
       error('Extraction de tet3d : option non implemente')
     end
   else
     error('Extraction de tet3d : option non reconnue')
   end
 
endfunction  

