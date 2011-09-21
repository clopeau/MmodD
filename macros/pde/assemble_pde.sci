// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in=assemble_pde(%in,opt)
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
    //nom_pde=name(%in);
    timer();
    funcprot(0)
    execstr('%in=assemble_pde_'+typeof(evstr(%in.var))+'(%in,opt)')
    funcprot(1)
endfunction
  
