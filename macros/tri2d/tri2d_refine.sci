// Copyright (C) 2010 - Marcel Ndeffo & Karine Mari
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

//Description:
//this function refines the mesh.
//Parameters: 
//th: It is assumed the parameter 'th' have a tri2d's construction.
//Function Modified by Karine Mari:
//PB: Bounderies were not refined/unrefined as well as the rest of the mesh.
//Solution: A simple implement of bounderies' refining

function th=tri2d_refine(th)

  ij=[th.Tri(:,1) th.Tri(:,2);th.Tri(:,2) th.Tri(:,3);th.Tri(:,1) th.Tri(:,3)];
  ij=gsort(ij,'c','i');
  ij=unique(ij,1);
  mn=max(ij);
  //on genere une matrice pratiquement vide sparse pour economiser le cout de stockage
  sp=sparse(ij,(1:size(ij,1))'+size(th.Coor,1),[mn mn]');//on remplit sp avec les numeros qu'on souhaite attribuer
  sp=sp+sp';//sp doit etre symetrique!!!
  sp1=zeros(size(th.Tri,1),1);sp2=sp1;sp3=sp1;
  //recuperation des indices stockés dans sp segment par segment
  for i=1:size(th.Tri,1)
    [aaa, sp1(i),aaa]=spget(sp(th.Tri(i,1),th.Tri(i,2)));
  end
  for i=1:size(th.Tri,1)
    [aaa, sp2(i),aaa]=spget(sp(th.Tri(i,1),th.Tri(i,3)));
  end
  for i=1:size(th.Tri,1)
    [aaa, sp3(i),aaa]=spget(sp(th.Tri(i,2),th.Tri(i,3)));
  end
  
  tri1=[th.Tri(:,1) sp1 sp2];
  tri2=[th.Tri(:,2) sp3 sp1];
  tri3=[th.Tri(:,3) sp2 sp3];
  tri4=[sp1 sp3 sp2];
  
  clear sp1,sp2,sp3;

  th.Tri=[tri1;tri2;tri3;tri4];
  clear tri1,tri2,tri3,tri4;
  Coor=(th.Coor(ij(:,1),:)+th.Coor(ij(:,2),:))/2;
  th.Coor=[th.Coor;Coor];
  
  for j=1:size(th.Bnd)
    T=th.Bnd(j);
    for i=1:(size(th.Bnd(j),1)-1)
      [aaa, noeud,aaa]=spget(sp(T(i),T(i+1)));
      th.Bnd(j)=[th.Bnd(j);T(i);noeud];
    end
    th.Bnd(j)=[th.Bnd(j);T($)];
    th.Bnd(j)=th.Bnd(j)((size(T,1)+1):$);
  end
  th.#=rand();
  
  
endfunction
