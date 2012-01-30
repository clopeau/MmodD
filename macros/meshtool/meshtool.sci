// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=meshtool(%th)

  %type=typeof(%th)

  if grep(%type,'2d')<>[]	
    execstr(%type+'_plot2d(%th)');
    NbDom=unique(%th.TriId);
    color_dom=round(linspace(1,256,length(NbDom)));
    %nbd=length(%th.Bnd)
    color_bdry=round(linspace(128,64,%nbd));
    %meshtool_legends(%th.BndId',color_bdry,string(NbDom), color_dom)
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" triangles")
  elseif grep(%type,'3d')<>[]
    execstr(%type+'_plot3d(%th)');
    %meshtool_legends(%th.BndId',round(linspace(1,256,length(%th.Bnd))));
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" tetrahedras")
  end
     
endfunction

 
