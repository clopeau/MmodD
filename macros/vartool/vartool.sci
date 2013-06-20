// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=vartool(%var,%view)
  
  %type=typeof(%var);
  %dim=typeof(evstr(%var.geo));
  
  f=scf();
  clf(f,'reset')

  if grep(%dim,'2d')<>[]
    if ~(exists("%view"))
      m  = uimenu('label','3d View');
      m1 = uimenu(m,'label','Turn in 3d','callback','vartool('+ ...
		  name_mmodd(%var)+',''3d'')')
      ierr=execstr(%type+'_plot2d(%var,cbar=''on'')','errcatch');
      if ierr>0
          error("MmodD error : by executing - "+%type+'_plot2d('+name_mmodd(%var)+',cbar=''on'')') 
      end
      xtitle('Name : '+name_mmodd(%var))
    elseif %view=="2d"
      m  = uimenu('label','3d View');
      m1 = uimenu(m,'label','Turn in 3d','callback','vartool('+ ...
		  name_mmodd(%var)+',''3d'')')
      ierr=execstr(%type+'_plot2d(%var,cbar=''on'')','errcatch');
      if ierr>0
          error("MmodD error : by executing - "+%type+'_plot2d('+name_mmodd(%var)+',cbar=''on'')') 
      end
      xtitle('Name : '+name_mmodd(%var))
    else
      m  = uimenu('label','2d View');
      m1 = uimenu(m,'label','Turn in 2d','callback','vartool('+ ...
		  name_mmodd(%var)+',''2d'')')
      ierr=execstr(%type+'_plot3d(%var,cbar=''on'')','errcatch');
      if ierr>0
          error("MmodD error : by executing - "+%type+'_plot3d('+name_mmodd(%var)+',cbar=''on'')') 
      end
      xtitle('Name : '+name_mmodd(%var))
    end
  elseif grep(%dim,'3d')<>[]
    ierr=execstr(%type+'_plot3d(%var,cbar=''on'')','errcatch');
    if ierr>0
          error("MmodD error : by executing - "+%type+'_plot3d('+name_mmodd(%var)+',cbar=''on'')') 
    end
    xtitle('Name : '+name_mmodd(%var))
  end
  
  if ierr>0
    error("MmodD error : vartool is not implemented for "+%type+ ...
	  " type or check your variable") 
  end
endfunction

 
