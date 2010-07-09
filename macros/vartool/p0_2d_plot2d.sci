function p0_2d_plot2d(v)
    %th=evstr(v.geo);
    rect =[min(%th);max(%th)]';
    clf()
    plot2d(0,0,0,strf="031",rect=rect);
    coulmax=256;
    xset("colormap",rgbcolor(coulmax))
    
    [np,nt]=size(%th);
    zminmax=[min(v.Cell),max(v.Cell)];
    colorbar(zminmax(1),zminmax(2));
    if zminmax(1)~=zminmax(2)
      coul=int((coulmax-1)*(v.Cell-zminmax(1))/(zminmax(2)-zminmax(1)))+1;
      coul(coul>coulmax)=0;
      coul(coul<1)=0;
    else
      coul=zeros(v.Cell);
      coul(v.Cell==mi)=int(coulmax/2);
    end
    
    xx=matrix(%th.Coor(%th.Tri,1),-1,3)';
    yy=matrix(%th.Coor(%th.Tri,2),-1,3)';
    xfpolys([xx ; xx(1,:)],[yy ; yy(1,:)],coul);
    xtitle(name(v)+' : '+v.Id)
    
endfunction
  
