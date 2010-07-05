function th=%tet3d_a_tri3d(th,s)

if size(th)==0  // vide
  th.BndId(1)=s.Id;
  th.Coor=s.Coor;
  th.Bnd(1)=s.Tri;
  th.Tmp=s.Bnd
else           // on ajoute
  th.BndId($+1)=s.Id;
  
  // Calcul des longueurs de frontière
  
  n1=length(th.Tmp);
  N1=zeros(1:n1);
  for i=1:n1
    N1(i)=length(th.Tmp(i));
  end
  n2=length(s.Bnd);
  N2=zeros(1:n2);
  for i=1:n2
    N2(i)=length(s.Bnd(i))-s.BndPerio(i);
  end
  
  if n1==0      // pas de bords libre
    th.Bnd($+1)=size(th)+s.Tri;
    th.Coor=[th.Coor;s.Coor];
    th.Tmp=s.Bnd
  elseif n2==0  // pas de nouveaux bord
    th.Bnd($+1)=size(th)+s.Tri;
    th.Coor=[th.Coor;s.Coor];
  else          // on cherche à joindre
    // Attention cela ne marche que s'il y a qu'une frontiere 
    // périodique 
    Ab=~ones(N2); // Bool 
    Ib=zeros(Ab); // indice de liason des frontieres de s.Bnd -> th.Tmp
    nn=size(th);
    tol=5e-1;     // tolerance relative
    // recherche des frontieres de même cardinal et proche
    for i=1:n1
      for j=find(N1(i)==N2)
	res1=max(abs(th.Coor(th.Tmp(i),:)-s.Coor(s.Bnd(j)(1:N2(j)),:)));
	res2=max(abs(th.Coor(th.Tmp(i)((1+s.BndPerio(j)):N2(j)),:)...
	    -s.Coor(s.Bnd(j)(N2(j):-1:(1+s.BndPerio(j))),:)));
	a=norm(th.Coor(th.Tmp(i)(1),:)-th.Coor(th.Tmp(i)(2),:));
	//disp([res1/a,res2/a]);
	if (res2/a)<tol
	  s.Bnd(j)=s.Bnd(j)($:-1:1);
	  Ab(j)=%t;
	  Ib(j)=i;
	elseif (res1/a)<tol
	  Ab(j)=%t;
	  Ib(j)=i;
	end
      end
    end
    // renumerotation des nouds
    bool=~zeros(size(s.Coor,1),1);
    for j=1:n2
      if Ab(j)
	bool(s.Bnd(j))=%f;
      end
    end
    s.Coor=s.Coor(bool,:);
    th.Coor=[th.Coor;s.Coor]
    
    // renumerotation des triangles avec les anciens
    bool=nn+cumsum(bool+0);
    for j=find(Ab)
      bool(s.Bnd(j)(1:N2(j)))=th.Tmp(Ib(j));
    end
    // on supprime dans Tmp ceux qui sont connecte
    for i=sort(Ib(Ab))
      th.Tmp(i)=null();
    end
    // ajout des non connecte a Tmp
    for j=find(~Ab)
      th.Tmp($+1)=bool(s.Bnd(j));
    end
    
    th.Bnd($+1)=matrix(bool(s.Tri),-1,3);
  end
end
// traitement des periodicite
for i=1:length(th.Tmp)
  if th.Tmp(i)(1)==th.Tmp(i)($)
    th.Tmp(i)=th.Tmp(i)(1:$-1);
  end
end   
endfunction
