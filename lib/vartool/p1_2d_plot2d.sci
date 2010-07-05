function p1_2d_plot2d(v)
    %th=evstr(v.geo);
    rect =[min(%th);max(%th)]';
    xbasc()
    coulmax=64;
    xset("colormap",rgbcolor(coulmax))
    
    [np,nt]=size(%th);
    triangl=[(1:nt)'  %th.Tri  zeros(nt,1)]
    zminmax=[min(v.Node),max(v.Node)];
    colorbar(zminmax(1),zminmax(2));
    fec(%th.Coor(:,1),%th.Coor(:,2),triangl,full(v.Node),...
	strf="031",rect=rect,zminmax=zminmax)
    xtitle(name(v)+' : '+v.Id)
    
endfunction
  
