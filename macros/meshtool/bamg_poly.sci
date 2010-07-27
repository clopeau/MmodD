// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  th=bamg_poly(polyg,nvert)
// pôle polygone polyg.corner : liste des coins
// nvert : nombre de points par segment
// renvoi par defaut le carre unite 
  [lhs,rhs]=argn(0);
  if rhs==0 
    // Un carre unite
    polyg=[0,0;1,0;1,1;0,1]';
    nvert=ones(1:4);
  elseif rhs==1
     nvert=ones(1:size(polyg,'c'));
  elseif rhs>2
     disp('erreur dans  bamg_poly : trop d''arguments')
     return
  end
  
  nc=size(polyg,'c'); // number of corner
  ListOfEdge=list();
  for i=1:nc
    j=pmodulo(i,nc)+1;
    t=linspace(0,1,max(nvert(i),2));
    ListOfEdge($+1)=polyg(:,i)*(1-t) +polyg(:,j)*t;
  end
  
  // ---------------------------------
  // Ecriture pour interface avec BAMG
  // ---------------------------------
  bamgf='/tmp/bamg_'+part(string(rand(1)*1000000),1:6);
  u=file('open',bamgf+'.geo','unknown')
  
  fprintf(u,'MeshVersionFormatted 0')
  fprintf(u,'Dimension 2');
  //fprintf(u,'MaximalAngleOfCorner 46');

  // ---- Section des points
  nb_vertice=sum(max(nvert,2)-1)
  fprintf(u,'Vertices '+string(nb_vertice));
  vertice_cpt=0;
  for Edge=ListOfEdge
    for tmp=Edge(:,1:$-1)
      vertice_cpt=vertice_cpt+1;
      fprintf(u,string(tmp(1))+' '...
	    +string(tmp(2))+' '...
	    +string(vertice_cpt));
    end
  end
  
  // ---- Section Edges
  fprintf(u,'Edges '+string(nb_vertice));
  edge_cpt=0;
  vertice_cpt=0;
  for Edge=ListOfEdge
    edge_cpt=edge_cpt+1;
    for tmp=Edge(:,1:$-1)
      vertice_cpt=vertice_cpt+1;
      fprintf(u,string(vertice_cpt)+' '...
	    +string(pmodulo(vertice_cpt,nb_vertice)+1)+' '...
	    +string(edge_cpt));
    end
  end
  
  
  file('close',u);
  
   //-------------------------- Execution Bamg --------------------
   // processing bamg
   txt=unix_g('bamg  -nbv 100000 -g '+bamgf+'.geo -o '+bamgf+'.msh');
   //write(%io(2),txt);
   if (grep(txt,'Error')~=[]) | (txt==[])
     write(%io(2),txt)
     error('bamg process error')
     return
   end

   //------------------------- Lecure des donnees ------------------
   //th.Id=th.Id+' bamg '+date();
   ierr=execstr( 'u=file(''open'','''+bamgf+'.msh'',''unknown'')' ,'errcatch','n'); 
   if ierr
     error('------------------- Erreur dans Bamg ! -------------------');
   end
   th=tri2d('bamg')
   //---- les points
   ligne=""
   while ligne~="Vertices"
     ligne=read(u,1,1,'(a)');
   end
   
   nbvert=read(u,1,1);
   tmp=read(u,nbvert,3);
   th.Coor=tmp(:,1:2);

   //----- les aretes
   ligne=""
   while ligne~="Edges"
     ligne=read(u,1,1,'(a)');
   end
   nbedge=read(u,1,1);
   tmp=read(u,nbedge,3);
   for i=1:nc
     ind=find(tmp(:,3)==i)
     th.Bnd(i)=[tmp(ind,1);tmp(ind($),2)];
   end
   th.BndId=string(1:nc);
   //----- les triangles
   ligne=""
   while ligne~="Triangles"
     ligne=read(u,1,1,'(a)');
   end
   nbtri=read(u,1,1);
   tmp=read(u,nbtri,4);
   // on ne récupere que le premier sous domaine !
   // attention 
   th.Tri=tmp(tmp(:,4)==1,1:3);
 
   file('close',u);
   unix('rm '+bamgf+'*');

endfunction

