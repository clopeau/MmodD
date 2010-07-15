function p1_2d_plot2d(v)
    bool=%t
    %th=evstr(v.geo);
    rect =[min(%th);max(%th)]';
    clf()
    coulmax=64;
    xset("colormap",rgbcolor(coulmax))
    
    [np,nt]=size(%th);
    triangl=[(1:nt)'  %th.Tri  zeros(nt,1)]
    if v.Node==[],disp('  --- no variable ---');bool=%f
    else
    zminmax=[min(v.Node),max(v.Node)];
    colorbar(zminmax(1),zminmax(2));
    fec(%th.Coor(:,1),%th.Coor(:,2),triangl,full(v.Node),...
	strf="031",rect=rect,zminmax=zminmax)
	xtitle(name(v)+' : '+v.Id)
   end
   if bool==%f,
          xset("font",1,5);
     xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
     xset("wdim",350,150);
    end
endfunction
  
