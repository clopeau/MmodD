function %u=interpol_df2d(%u,%fonction)
    if grep(%fonction,'x')~=[]
      execstr('x=df2d('+%u.geo+')');
      execstr('x.Node=x_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')')
    end
    if grep(%fonction,'y')~=[]
      execstr('y=df2d('+%u.geo+')');
      execstr('y.Node=y_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=df2d('+%u.geo+')');
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
