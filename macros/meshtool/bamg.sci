// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [th,txt]=bamg(th,ns)
// fonction d'interface avec bamg
   [lhs,rhs]=argn(0)
   
   bamgf=TMPDIR+filesep()+'bamg_'+part(string(rand(1)*1000000),1:6);
   
   list_open_file=file()
   ierr=execstr("u=file(''open'',bamgf+''.geo'',''unknown'')",'errcatch')
   if ierr<>0
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       file('close',list_open_file)
     end
     error(str,n)
   end
   fprintf(u,'MeshVersionFormatted 0')
   fprintf(u,'Dimension 2');
   fprintf(u,'MaximalAngleOfCorner 46');
   fprintf(u,'AngleOfCornerBound 160');
   
   // on compte 
   nBnd=length(th.Bnd);
   inBnd=zeros(1,nBnd);
   //--- les noeuds
   nv=0
   for l=1:nBnd
     th.Bnd(l)=matrix(th.Bnd(l),-1,1)
     inBnd(l)=length(th.Bnd(l))-th.BndPerio(l);
   end
   nv=sum(inBnd);
   
   if th.BndPerio(1)
     fprintf(u,'Vertices %i',nv);
     id1=1;
     for i=1:nBnd
       id2=id1+inBnd(i)-1;
       ind=th.Bnd(i)(1:inBnd(i));
       fprintf(u,'%3.12f %3.12f %i\n',th.Coor(ind,:),(id1:id2)');
       id1=id2+1;
     end
   else
     fprintf(u,'Vertices %i',size(th.Coor,1));
     fprintf(u,'%3.12f %3.12f %i\n',th.Coor,(1:size(th.Coor,1))');
   end
   
   //--- les aretes
   ne=0;
   for l=1:nBnd
     ne=ne+length(th.Bnd(l))-1;
   end
   
   fprintf(u,'Edges %i',ne);
   id1=1;
   for i=1:nBnd
     id2=id1+inBnd(i)-1;
     if th.BndPerio(i)
       Ed=[id1:id2 ;[id1+1:id2,id1]]';
     else
       Ed=[th.Bnd(i)(1:$-1),th.Bnd(i)(2:$)];
     end
     fprintf(u,'%i %i %i\n',Ed,i(ones(inBnd(i),1)));
     id1=id2+1;
   end
   if and(th.BndPerio)
     fprintf(u,'SubDomain %i',1)
     fprintf(u,'2 1 2 1')
   end
   
   file('close',u);
   //-------------------------- Execution Bamg --------------------
   // processing bamg
   global root_drop
   if (getos()=="Windows") then
       txt=unix_g(root_drop+'\bin\bamg.Win.exe  -nbv 100000 -g '+bamgf+'.geo -o '+bamgf+'.msh');
   elseif  (getos()=="Darwin") then 
       txt=unix_g(root_drop+'/bin/bamg.darwin  -nbv 100000 -g '+bamgf+'.geo -o '+bamgf+'.msh');
   elseif  (getos()=="Linux") then 
       txt=unix_g(root_drop+'/bin/bamg.linux  -nbv 100000 -g '+bamgf+'.geo -o '+bamgf+'.msh');    
   end
   
   write(%io(2),txt);
   if (grep(txt,'Error')~=[]) | (txt==[])
     write(%io(2),txt)
     error('bamg process error')
     return
   end

   //------------------------- Lecure des donnees ------------------
   //th.Id=th.Id+' bamg '+date();
   list_open_file=file()
   ierr=execstr( 'u=file(''open'','''+bamgf+'.msh'',''unknown'')' ,'errcatch','n'); 
   if ierr
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       file('close',list_open_file)
     end
     error('------------------- Erreur dans Bamg ! -------------------');
   end
   
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
   for i=1:nBnd
     ind=find(tmp(:,3)==i)
     th.Bnd(i)=[tmp(ind,1);tmp(ind($),2)];
   end
   //----- les triangles
   ligne=""
   while ligne~="Triangles"
     ligne=read(u,1,1,'(a)');
   end
   nbtri=read(u,1,1);
   tmp=read(u,nbtri,4);
   // on ne récupere que le premier sous domaine !
   // attention 
   th.Tri=tmp(:,1:3);
   th.TriId=ones(tmp(:,1));
   th.BndId="F"
   file('close',u);
   unix('rm '+bamgf+'*');

endfunction
