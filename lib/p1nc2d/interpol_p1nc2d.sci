function %u=interpol_p1nc2d(%u,%fonction)
    // recherche des variables cartésiennes
    if grep(%fonction,'x')~=[]
      execstr('x=p1nc2d('+%u.geo+')');
      execstr('x.Face=x_'+typeof(evstr(%u.geo))+'_Face('+%u.geo+')')
    end
    if grep(%fonction,'y')~=[]
      execstr('y=p1nc2d('+%u.geo+')');
      execstr('y.Face=y_'+typeof(evstr(%u.geo))+'_Face('+%u.geo+')');
    end
    dim=evstr('typeof('+%u.geo+')');
    dim=part(dim,length(dim)-1:length(dim))
    if (dim=='3d') & (grep(%fonction,'z')~=[])
      execstr('z=p1nc2d('+%u.geo+')');
      execstr('z.Face=z_'+typeof(evstr(%u.geo))+'_Face('+%u.geo+')');
    end
    %uloc=evstr(%fonction);
    
    if type(%uloc)~=1
      %u.Face=%uloc.Face;
    elseif size(%uloc,'r')==1
      %u.Face=%uloc(ones(size(%u),1));
    else
      %u.Face=%uloc;
    end
endfunction
