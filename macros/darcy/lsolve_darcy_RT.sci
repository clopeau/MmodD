function [ploc,vloc]=lsolve_darcy_RT(pb,opt)


   //--- Pression ------
    ploc=evstr(pb.pression);
    ploc.Face=zeros(size(evstr(pb.pression)));
    if rhs==1
      ploc.Face=pb.A\pb.b;
    elseif opt=="grad"
      timer()
      ploc.Face=GradConj(pb.A,pb.b,1E-7);
    elseif opt=="qmr"
      timer()
      ploc.Face=qmr(pb.A,pb.b);
    elseif opt=="gmres"
      timer()
      ploc.Face=gmres(pb.A,pb.b);
    end      
    
    //----- Vitesse -----------
    
    
    vloc=[]
endfunction
