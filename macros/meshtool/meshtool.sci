// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=meshtool(%th)

  %type=typeof(%th)

  if grep(%type,'2d')<>[]
	
	execstr(%type+'_plot2d(%th)');
  elseif grep(%type,'3d')<>[]
	execstr(%type+'_plot3d(%th)');
  end
endfunction

 
