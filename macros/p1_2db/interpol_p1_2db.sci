function %u=interpol_p1_2db(%u,%fonction)
    if grep(%fonction,'x')~=[]
      execstr('x=p1_2db('+%u.geo+')');
      execstr('x.Node=x_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
      execstr('x.Cell=x_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')');
    end
    if grep(%fonction,'y')~=[]
      execstr('y=p1_2db('+%u.geo+')');
      execstr('y.Node=y_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
      execstr('y.Cell=y_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')');
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=p1_2db('+%u.geo+')');
      execstr('z.Node=z_'+typeof(evstr(%u.geo))+'_Node('+%u.geo+')');
      execstr('z.Cell=z_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')');
    end
    %uloc=evstr(%fonction);

    if type(%uloc)~=1
      %u.Node=%uloc.Node;
      %u.Cell=%uloc.Cell;
    elseif size(%uloc,'r')==1
      [n,t]=size(%u);
      %u.Node=%uloc(ones(n,1));
      %u.Cell=%uloc(ones(t,1));
    else
      [n,t]=size(%u);
      %u.Node=%uloc(1:n);
      %u.Cell=%uloc(n+1:$);
    end
endfunction
