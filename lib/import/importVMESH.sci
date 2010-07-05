function th=importVMESH(nombase)
  // import des maillags GRUMMP
  
   u=file('open',nombase+'.vmesh','old');
   th=tet3d(nombase)
   // n(1) : ncells
   // n(2) : nfaces
   // n(3) : nbfaces
   // n(4) : nverts
   n=read(u,1,4)
   // Lecture des Coordonnes
   th.Coor=read(u,n(4),3);
   // Lecture des face
   tmp1=read(u,n(2),5)
   // Lecture cellules
   tmp1=read(u,n(3),5)
   num=unique(tmp1(:,2));
   for i=1:length(num)
     th.BndId(i)=string(num(i));
     th.Bnd(i)=tmp1(tmp1(:,2)==num(i),3:5)+1;
   end
   th.Tet=read(u,n(1),4)+1;
   
   file('close',u);
   
endfunction
