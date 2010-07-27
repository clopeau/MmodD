// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out = %p1_1d_e(varargin)
   [lhs,rhs]=argn(0);
   
   in=varargin($);
   
   // Extraction avec 1 parmetre
   //  cas "par composante vectorielle"
   if rhs==2 & type(varargin(1))~=10
     G=evstr(in.geo)
     out=in.Node(:,varargin(1))
   // cas "par frontiere"  
   elseif rhs==2 & type(varargin(1))==10
     G=evstr(in.geo)
     out=in.Node(G(varargin(1)),:)
   // cas "par composante vectorielle  et frontière"
   elseif rhs==3
     G=evstr(in.geo)
     out=in.Node(G(varargin(2)),varargin(1))
   else
     error('Extraction non-admise')
   end   
          
endfunction
