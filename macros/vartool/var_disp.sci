//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// gestion du menu vartools
function []=var_disp(var,etat)
//  clf();
//  rect =[min(var);max(var)]';
  
//  plot2d(1,1,[1],"030"," ",rect(1:4));
  
  
    if etat(1) 
      execstr(rac+'_plot2d(var)')
    else
      execstr(rac+'_plot3d(var)')
    end


endfunction
