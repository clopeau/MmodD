// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=vartool(%var)
 
  %type=typeof(%var)

  if grep(%type,'2d')<>[]
	ierr=execstr(%type+'_plot2d(%var)','errcatch');
  elseif grep(%type,'3d')<>[]
	ierr=execstr(%type+'_plot3d(%var)','errcatch');
  end
 
  if ierr>0
    error("MmodD error : vartool is not implemented for "+%type+ ...
	 " type or check your variable") 
  end
endfunction

 
