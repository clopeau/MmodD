// Copyright (C) 2011 - Bouvet Paul-Edouard
// Copyright (C) 2011 - Chun Yuk Shan Nadège
// Copyright (C) 2011 - Mazzocco Pauline
// Copyright (C) 2011 - Moncel Marie
// Copyright (C) 2011 - Vacher Anthony
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
// 

function [colormap]=DarkYellowColorMap(u,level)
    maxi=max(u.Node);
    mini=min(u.Node);
    Yellow=[0.854,0.647,0.126];
    colormap=zeros(256,3);
    if (maxi>mini)
      nbYellow=min(256,floor(256*(level-mini)/(maxi-mini)));
    else
      nbYellow=0;
    end
    
    if nbYellow>0
      colormap(1:nbYellow,:)=Yellow(ones(1:nbYellow),:);
    end
endfunction


th=read_tri2d_GMSH(mmodd_getpath()+"/demos/2d/Mesh_example/Cow_1.msh");

u=p1(th,init_u);
u.Node(u.Node<0)=0;
v=p1(th,init_v);
u.Node(u.Node<0)=0;

pb1=pde(u);
for i=th.BndId
  execstr('pb1.'+i+'=""Dn(u)=0""');
end
pb2=pde(v);
for i=th.BndId
  execstr('pb2.'+i+'=""Dn(v)=0""');
end

function out=H(u,v)
   out= (rho* v * u)/(1 + u + K* u * u);
endfunction
pb1.eq="-delta*Laplace(u)+Id(u) =  delta* gama*(a - u - H(u,v)) + u ";
pb2.eq="-delta*d*Laplace(v)+Id(v) = delta* gama*(alpha*(b-v)-H(u,v))+ v";


assemble(pb1,1);
LUpb1 = umf_lufact(pb1.A);
assemble(pb2,1);
LUpb2 = umf_lufact(pb2.A);

t=0;

h=scf();
h.color_map = DarkYellowColorMap(u,level)
p1_2d_plot2d(u,cbar='on');
xtitle('t='+string(t))

for i=1:NBrepet
  t=t+delta;
  assemble(pb1,2);
  u.Node=umf_lusolve(LUpb1,pb1.b);
  u.Node(u.Node<0)=0;
  
  drawlater(); 
  h=gcf();
  clf(h)
  h.color_map = DarkYellowColorMap(u,level);
  p1_2d_plot2d(u,cbar='on');
  xtitle('t='+string(t)+'  v_min '+string(min(v))+' v_max='+string(max(v)));
  drawnow();
  
  assemble(pb2,2);
  v.Node=umf_lusolve(LUpb2,pb2.b);
  v.Node(v.Node<0)=0;
  
end
      
