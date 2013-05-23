// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  vector_gmv(u,%v)
   [n,dim]=size(%v)
   ttype=typeof(%v)

   Var2dNode=['df2d' 'q1_2d' 'q1p2d' 'p1_2d']
   if grep(Var2dNode,ttype)~=[]&(dim==2)
     mfprintf(u,'velocity 1\n');
     mfprintf(u,"%f\n",%v.Node(:,1));
     mfprintf(u,"%f\n",%v.Node(:,2));
     mfprintf(u,"%f\n",zeros(%v.Node(1,:)));
   end
   
   Var3dNode=['df3d' 'q1_3d' 'q1p3d' 'p1_3d']
   if grep(Var3dNode,ttype)~=[]&(dim==3)
     mfprintf(u,'velocity 1\n');
     mfprintf(u,"%f\n",%v.Node(:,1));
     mfprintf(u,"%f\n",%v.Node(:,2));
     mfprintf(u,"%f\n",%v.Node(:,3));
   end

 endfunction 

