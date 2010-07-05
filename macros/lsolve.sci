function [txt,tps]=lsolve(pb,%method)
    [lhs,rhs]=argn(0);
    timer()
    select typeof(pb)
      // --------------------- EDP ---------------------
    case 'edp'
      if rhs==2
	uloc=lsolve_edp(pb,%method)
      else
	uloc=lsolve_edp(pb)
      end
      tps=timer();
      txt='Solving process : '+string(tps)+' secondes';
      execstr('['+pb.var+']=return(uloc)')
      
      // --------------------- Darcy ---------------------
    case 'darcy'
      if rhs==2
	[ploc,vloc]=lsolve_darcy(pb,%method)
      else
	[ploc,vloc]=lsolve_darcy(pb)
      end
      tps=timer();
      txt=' Solving  process  : '+string(tps)+' secondes';
      execstr('['+pb.pression+','+pb.vitesse+']=return(ploc,vloc)')
     // --------------------- Stokes -----------------------
    case 'stokes'
      if rhs==2
        [ploc,vloc]=lsolve_stokes(pb,%method)
      else
        [ploc,vloc]=lsolve_stokes(pb)
      end
      tps=timer();
      txt=' Solving  process  : '+string(tps)+' secondes';
      execstr('['+pb.pression+','+pb.vitesse+']=return(ploc,vloc)')
    end
								
endfunction
  
