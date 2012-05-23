// Copyright (C) 2010-12 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %u=interpol_p1_2d(%u,%fonction)

    // particular case for a variable defining on subdomains
    execstr('[%np,%nt]=size('+%u.geo+')')
    %ind=~zeros(%np,1);
    %ind2=~ones(%nt,1);
    if %u.domain~=[]
      %ind=~%ind;
      for i=1:length(%u.domain)
	%tmp=evstr(%u.geo+'.TriId== %u.domain(i)');	
	execstr('%ind(unique('+%u.geo+'.Tri(%tmp,:)))=%t')
	%ind2=%ind2 | %tmp
      end
      %u.BoolNode=%ind;
      %u.BoolTri=%ind2
    end
    
    if grep(%fonction,'x')~=[]
      execstr('x=p1_2d('+%u.geo+')');
      execstr('x.Node=x_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')')
      x.Node=x.Node(%ind);
    end
    if grep(%fonction,'y')~=[]
      execstr('y=p1_2d('+%u.geo+')');
      execstr('y.Node=y_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
      y.Node=y.Node(%ind);
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=p1_2d('+%u.geo+')');
      execstr('z.Node=z_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
      z.Node=z.Node(%ind);
    end
    %uloc=evstr(%fonction);
    
    if type(%uloc)~=1
      %u.Node=%uloc.Node;
    elseif size(%uloc,'r')==1
      %u.Node=%uloc(ones(size(%u),1));
    else
      %u.Node=%uloc;
    end
endfunction
