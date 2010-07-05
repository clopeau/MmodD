function out=%RT_e(varargin)
   [lhs,rhs]=argn(0);

   // v variable p1
   v=varargin($);
   // Extraction avec 1 parametre
   //  cas "par composante vectorielle"
   if rhs==2 & type(varargin(1))~=10
     G=evstr(v.geo)
     out=v.Face(:,varargin(1))
   // cas "par frontiere"  
   elseif rhs==2 & type(varargin(1))==10 
     G=evstr(v.geo)
     out=v.Face(G(varargin(1)),:)
   // cas "par composante vectorielle et frontière" 
   elseif rhs==3 
      G=evstr(v.geo)
      out=v.Face(G(varargin(2),'f'),varargin(1));
    else
      error('Incorrect number of argument in %p1_e')
    end    
endfunction
  
      
