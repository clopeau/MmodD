function [out]=%p1_2db_e(varargin)
//opt precise noeud 'n' ou cellule 'c'

   [lhs,rhs]=argn(0);
    // v variable p1
    v=varargin($);
    
   // Extraction avec 1 parametre
   //  cas "par composante vectorielle"    
    if rhs==2 & type(varargin(1))~=10
      out=[v.Node(:,varargin(1));v.Cell(:,varargin(1))];
      // cas "par frontiere"       
    elseif rhs==2 & type(varargin(1))==10 
      g=evstr(v.geo)
      out=[v.Node(g(varargin(1)),:);v.Cell(g(varargin(1)),:)];
      // cas "par composante vectorielle  et frontière"
    elseif rhs==3
      g=evstr(v.geo)
      out=[v.Node(g(varargin(2)),varargin(1));v.Cell(g(varargin(2)),varargin(1))];  
    else
      error('Incorrect number of argument in %p1_e')
    end
 
    
endfunction
  
      
