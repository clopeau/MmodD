// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [th,txt]=bamg(th,ns)
// fonction d'interface avec bamg
   [lhs,rhs]=argn(0)
   
   bamgf=TMPDIR+filesep()+'bamg_'+part(string(rand(1)*1000000),1:6);
   
   list_open_file=file()
   ierr=execstr("u=mopen("""+bamgf+".geo"",""wt"")",'errcatch')
   if ierr<>0
     [str,n]=lasterror()
     if length(list_open_file)<length(file()) then
       [tmp,k]=intersect(list_open_file,file());
       list_open_file(k)=[];
       mclose(list_open_file)
     end
     error(str,n)
   end
   mfprintf(u,'MeshVersionFormatted 0\n')
   mfprintf(u,'Dimension 2\n');
   mfprintf(u,'MaximalAngleOfCorner 46\n');
   mfprintf(u,'AngleOfCornerBound 160\n');
   
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
     mfprintf(u,'Vertices %i\n',nv);
     id1=1;
     for i=1:nBnd
       id2=id1+inBnd(i)-1;
       ind=th.Bnd(i)(1:inBnd(i));
       mfprintf(u,'%3.12f %3.12f %i\n',th.Coor(ind,:),(id1:id2)');
       id1=id2+1;
     end
   else
     mfprintf(u,'Vertices %i\n',size(th.Coor,1));
     mfprintf(u,'%3.12f %3.12f %i\n',th.Coor,(1:size(th.Coor,1))');
   end
   
   //--- les aretes
   ne=0;
   for l=1:nBnd
     ne=ne+length(th.Bnd(l))-1;
   end
   
   mfprintf(u,'Edges %i\n',ne);
   id1=1;
   for i=1:nBnd
     id2=id1+inBnd(i)-1;
     if th.BndPerio(i)
       Ed=[id1:id2 ;[id1+1:id2,id1]]';
     else
       Ed=[th.Bnd(i)(1:$-1),th.Bnd(i)(2:$)];
     end
     mfprintf(u,'%i %i %i\n',Ed,i(ones(inBnd(i),1)));
     id1=id2+1;
   end
//   if and(th.BndPerio)
//     mfprintf(u,'SubDomain %i\n',1)
//     mfprintf(u,'2 1 2 1')
//   end
   
   mclose(u);
   //-------------------------- Execution Bamg --------------------
   // processing bamg
   global root_drop
   if (getos()=="Windows") then
       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe  -nbv 1000000 -g '+bamgf+'.geo -o '+bamgf+'.msh');
   elseif  (getos()=="Darwin") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin  -nbv 1000000 -g '+bamgf+'.geo -o '+bamgf+'.msh');
   elseif  (getos()=="Linux") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux  -nbv 1000000 -g '+bamgf+'.geo -o '+bamgf+'.msh');    
   end
   
   //write(%io(2),txt);
   if (grep(txt,'Error')~=[]) | (txt==[])
     write(%io(2),txt)
     error('bamg process error')
     return
   end

   //------------------------- Lecure des donnees ------------------
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
   file('close',u)
   
   // --- lecture
   th=read_tri2d_BAMG(bamgf+'.msh')
   
   // To concerve geometric file definition
   tmp=getfield(1,th);
   if grep(tmp,'bamg_geo_file')==[] then
          setfield(1,[tmp;'bamg_geo_file'],th)
   end

   th.bamg_geo_file=bamgf+'.geo'
   
   //unix('rm '+bamgf+'*');

endfunction
