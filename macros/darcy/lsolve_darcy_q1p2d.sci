function [ploc,vloc]=lsolve_darcy_q1p2d(pb,opt)


   //--- Pression ------
    ploc=evstr(pb.pression);
    ploc.Node=zeros(size(evstr(pb.pression)));
    if rhs==1
      ploc.Node=pb.A\pb.b;
    elseif opt=="grad"
      timer()
      ploc.Node=GradConj(pb.A,pb.b,1E-7);
    elseif opt=="qmr"
      timer()
      ploc.Node=qmr(pb.A,pb.b);
    elseif opt=="gmres"
      timer()
      ploc.Node=gmres(pb.A,pb.b);
    end      
    
    //----- Vitesse -----------

    vloc=Grad(ploc);
    vloc.Node=vloc.Node*(pb.K');
    for i=1:2
      b=evstr('q1p2d('+pb.geo+','''+pb.f(i)+''')')
      vloc.Node(:,i)=-(b.Node+vloc.Node(:,i));
    end
     
        
endfunction
