function %u=interpol_p0_1d(%u,%fonction)
    // recherche des variables cartésiennes
    if grep(%fonction,'x')~=[]
      execstr('x=p0_1d('+%u.geo+')');
      execstr('x.Cell=x_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')')
    end
    if grep(%fonction,'y')~=[]
      execstr('y=p0_1d('+%u.geo+')');
      execstr('y.Cell=y_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')');
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=p0_1d('+%u.geo+')');
      execstr('z.Cell=z_'+typeof(evstr(%u.geo))+'_Cell('+%u.geo+')');
    end
    %uloc=evstr(%fonction);
    
    if type(%uloc)~=1
      %u.Cell=%uloc.Cell;
    elseif size(%uloc,'r')==1
      %u.Cell=%uloc(ones(size(%u),1));
    else
      %u.Cell=%uloc;
    end
endfunction
