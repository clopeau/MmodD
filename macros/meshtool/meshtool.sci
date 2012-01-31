// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=meshtool(%th)
  
  // configuration 
  %type=typeof(%th)
  f=scf();
  clf(f,'reset')
  my_plot2d= gcf();
  coulmax=256;
  my_plot2d.color_map=jetcolormap(coulmax);
  
  // tri2d ...
  if grep(%type,"tri2d")<>[]	
    NbDom=unique(%th.TriId);
    color_dom=round(linspace(1,coulmax,length(NbDom)));
    %nbd=length(%th.Bnd)
    color_bnd=round(linspace(1,coulmax,%nbd))
    execstr(%type+'_plot2d(%th,color_dom=color_dom,color_bnd=color_bnd)');
    %meshtool_legends(%th.BndId',color_bnd,string(NbDom), color_dom)
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" triangles")
    // tri3d 
  elseif grep(%type,"tri3d")<>[]	
    NbDom=unique(%th.TriId);
    color_dom=round(linspace(1,coulmax,length(NbDom)));
    %nbd=length(%th.Bnd)
    if %nbd>0
      color_bnd=round(linspace(1,coulmax,%nbd))
    else
      color_bnd=[]
    end
    execstr(%type+'_plot3d(%th,color_dom=color_dom,color_bnd=color_bnd)');
    %meshtool_legends(%th.BndId',color_bnd,string(NbDom), color_dom)
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" triangles")
  // tet3d ....
  elseif grep(%type,'tet3d')<>[]
    execstr(%type+'_plot3d(%th)');
    %meshtool_legends(%th.BndId',round(linspace(1,256,length(%th.Bnd))));
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" tetrahedras")
  end
     
endfunction

 
