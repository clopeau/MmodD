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
    mmodd_legends( ["Domain "+string(NbDom); "Bdry "+%th.BndId']..
    ,[color_dom, color_bdry])
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" triangles")
  elseif grep(%type,'3d')<>[]
    execstr(%type+'_plot3d(%th)');
    mmodd_legends(%th.BndId',round(linspace(1,256,length(%th.Bnd))),4);
    [%np,%nt]=size(%th);
    xtitle(name_mmodd(%th)+" : "+string(%np)+" points"+"  "+string(%nt)+" tetrahedras")
  end
     
endfunction

 
