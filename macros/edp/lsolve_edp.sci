// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %uloc=lsolve_edp(pb,opt)
    [lhs,rhs]=argn(0);
    typeedp=evstr('typeof('+pb.var+')');
    typeedp=part(typeedp,length(typeedp)-1:length(typeedp));
    if (typeedp=='2d')
      %uloc=evstr(pb.var);
      %uloc.Node=pb.A\pb.b;
    else
      %uloc=evstr(pb.var);
      if typeof(%uloc)=='p1nc3d'
	%uloc.Face=bicg(pb.A,pb.b);
      else
	%uloc.Node=bicg(pb.A,pb.b);
      end
    end   
endfunction
  
