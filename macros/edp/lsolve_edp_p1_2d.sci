// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [%uloc]=lsolve_edp_p1_2d(%pb,%opt)
    [lhs,rhs]=argn();
    %th=evstr(%pb.geo);
    [nf,nt]=size(evstr(%pb.geo));
    //--- variable --------------
    %uloc=evstr(%pb.var);
    %uloc.Node=zeros(size(evstr(%pb.var)),1);
    if rhs==1
      if with_module('umfpack')
	%x=umfpack(%pb.A,'\',%pb.b);
      else
	warning('umfpack module not installed... reinstall scilab with this module !')
	%x=%pb.A,'\',%pb.b;
      end
    elseif %opt=="cg"
      [%x,ierr]=pgc(%pb.A,%pb.b,zeros(%pb.b),10000,1e-13,5);
    elseif %opt=="cgnr"
      [%x,ierr]=pgcnr(%pb.A,%pb.b,zeros(%pb.b),50000,1e-13,100);
    elseif %opt=="gmres"
      [%x,ierr]=pgmres(%pb.A,%pb.b,zeros(%pb.b),10000,1e-13,40,10);
    elseif %opt=="bcg"
      [%x,ierr]=pbgc(%pb.A,%pb.b,zeros(%pb.b),10000,1e-13,100);
    elseif %opt=='pdbgc'
      [%x,ierr]=pdbgc(%pb.A,%pb.b,ones(%pb.b),10000,1e-13,1000);
    elseif %opt=='pbcgstab'
      [%x,ierr]=pbcgstab(%pb.A,%pb.b,ones(%pb.b),10000,1e-13,1000);
    elseif %opt=='qmr'
      [%x,ierr]=pqmr(%pb.A,%pb.b,ones(%pb.b),10000,1e-13,1000);  
    elseif %opt=='lu'
      Lup=umf_lufact(%pb.A);
      %x=umf_lusolve(Lup,%pb.b); 
      umf_ludel(Lup); 
    end      
    %uloc.Node=%x;
endfunction

  
