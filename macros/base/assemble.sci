// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [txt,tps]=assemble(%in,opt)
// opt option de differenciation d'assemblage du 1er et second membre
// par defaut les 2 sont assembles
// opt=1 : 1 er membre
// opt=2 : 2 eme membre

    [lhs,rhs]=argn(0);
    if rhs==1
      opt=1:2
    else
      opt=matrix(opt,1,-1);
    end
    nom_edp=name(%in);
    timer();
    execstr('%in=assemble_'+typeof(%in)+'(%in,opt)')
    tps=timer();
    txt='Assembling process : '+string(tps)+' secondes';
    execstr('['+nom_edp+']=return(%in);');
endfunction
  
