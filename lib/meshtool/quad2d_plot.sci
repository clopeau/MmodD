function []=quad2d_plot(th,opt,coul)
// Mesh visualisation
// th : type quad
// opt : "rect" pour "cadrer" le graphe ou rect=[xmin,ymin,xmax,ymax]
// coul : couleur d'affichage (noir par defaut)
//
// syntaxe
//
// quad_plot(th,["rect"],[cool]) ou quad_plot(th,rect=[xmin,ymin,xmax,ymax])
//

  [lhs,rhs]=argn(0);
  if rhs==1
    coul=2
  elseif rhs==2 
    if exists("rect",'local')
      coul=2;
      plot2d(0,0,0,strf="031",rect=rect);
    elseif type(opt)==10
      coul=2;
      if opt=='rect'
	strf="051"
      elseif opt=='iso'
	strf="031"
      else
	error('Option not implemented in quad2d_plot');
      end
      rect=size(th,"rect");
      if length(rect)==6, rect=rect([1 2 4 5]);end
      plot2d(0,0,0,strf=strf,rect=rect);
    elseif type(opt)==1
      coul=opt
    else
      error('Option not implemented in quad2d_plot');
    end
  elseif rhs==3 & ~exists("rect",'local')
    plot2d(0,0,0,"031",rect=size(th,"rect"));
  elseif rhs==3 & exists("rect",'local')
    plot2d(0,0,0,strf="031",rect=rect)
  elseif rhs==3 
    plot2d(0,0,0,"031",rect=size(th,"rect"));
  else
    error('Bad arguments in quad2d_plot');
  end
  
  triang=size(th.Quad,'r');

  x=matrix(th.Coor(th.Quad,1),triang,4)';
  y=matrix(th.Coor(th.Quad,2),triang,4)';
 
  x=[x;x(1,:)];
  y=[y;y(1,:)];
  xset("clipgrf");
  xpolys(x,y,coul*ones(1,triang));
  xset("clipoff");
endfunction
