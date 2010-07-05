function %in=assemble_edp(%in,opt)
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
    //nom_edp=name(%in);
    timer();
    execstr('%in=assemble_edp_'+typeof(evstr(%in.var))+'(%in,opt)')
endfunction
  
