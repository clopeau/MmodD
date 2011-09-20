// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  VNode_vtk(%u,%v)
   [%n,%dim]=size(%v)   
   %ttype=typeof(%v)
   %nomvar=name_mmodd(%v);
   if length(%nomvar)==0
     %nomvar='Vector_'+part(string(rand(1)*1000000),1:3);
   end
   %nomvar=strsubst(%nomvar,'%','')

   fprintf(%u,'VECTORS '+%nomvar+' float');
   
   Var2dNode=['df2d' 'q1_2d' 'q1p2d' 'p1_2d']
   Var3dNode=['p1_2d' 'q1_2d' 'df3d' 'q1_3d' 'q1p3d' 'p1_3d']
   if grep(Var2dNode,%ttype)~=[]&(%dim==2)
     fprintf(%u,"%g %g 0.\n ",%v.Node);
   elseif grep(Var3dNode,%ttype)~=[]&(%dim==3)
     fprintf(%u,"%g %g %g\n ",%v.Node);
   else
     error("exportVTK: The variable "+%nomvar+" must have 2 or 3 components")
   end

 endfunction 

