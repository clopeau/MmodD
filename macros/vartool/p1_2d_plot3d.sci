function p1_2d_plot3d(v)
    %th=evstr(v.geo);
    mi=min(v.Node); ma=max(v.Node);
    rect =[min(%th);mi;max(%th);ma]';
    flag=[0,1,4];
    ebox=rect([1 4 2 5 3 6]);
    xx=matrix(full(%th.Coor(%th.Tri,1)),-1,3)';
    yy=matrix(full(%th.Coor(%th.Tri,2)),-1,3)';
    zz=matrix(full(v.Node(%th.Tri)),-1,3)';
 
    xbasc()
    coulmax=256;
    xset("colormap",rgbcolor(coulmax))
    colorbar(mi,ma);
    coul=zz
    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
   // plot3d1([xx xx($:-1:1,:)],[yy yy($:-1:1,:)],..
	//[zz,zz($:-1:1,:)],flag=flag,ebox=ebox)
    plot3d([xx xx($:-1:1,:)],[yy yy($:-1:1,:)],..
	list([zz,zz($:-1:1,:)],[coul,coul($:-1:1,:)]),flag=flag,ebox=ebox)
    //plot3d(xx,yy,list(zz,coul),flag=[0,0,0]);
    //plot3d1(xx,yy,list(zz,coul),flag=flag,ebox=ebox)
    //plot3d1(xx,yy,zz,flag=[0,0,0])
 
    xtitle(name(v)+' : '+v.Id)
    
endfunction
  
