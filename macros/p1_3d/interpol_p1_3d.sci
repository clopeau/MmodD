// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %u=interpol_p1_3d(%u,%fonction)
    if grep(%fonction,'x')~=[]
      execstr('x=p1_3d('+%u.geo+')');
      execstr('x.Node=x_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')')
    end
    if grep(%fonction,'y')~=[]
      execstr('y=p1_3d('+%u.geo+')');
      execstr('y.Node=y_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=p1_3d('+%u.geo+')');
      execstr('z.Node=z_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
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
