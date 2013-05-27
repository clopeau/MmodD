// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [th,txt]=bamg(th,coef,ratio,hmax,hmin,errg,err,power,NbJacobi,maxsubdiv,anisomax,NbSmooth,omega,splitpbedge,nosplitpbedge,v,nbv,MaximalAngleOfCorner,AngleOfCornerBound)
// fonction d'interface avec bamg
   [lhs,rhs]=argn(0)
   
   // options for bamg
   opts="";
   if exists('coef','local')==1 then opts=opts+' -coef '+string(coef),end
   if exists('ratio','local')==1 then opts=opts+' -ratio '+string(ratio),end
   if exists('hmin','local')==1 then opts=opts+' -hmin '+string(hmin),end
   if exists('hmax','local')==1 then opts=opts+' -hmax '+string(hmax),end
   if exists('errg','local')==1 then opts=opts+' -errg '+string(errg),end
   if exists('err','local')==1 then opts=opts+' -err '+string(err),end
   if exists('ratio','local')==1 then opts=opts+' -ratio '+string(ratio),end
   if exists('power','local')==1 then opts=opts+' -power '+string(power),end
   if exists('NbJacobi','local')==1 then opts=opts+' -NbJacobi '+string(NbJacobi),end
   if exists('maxsubdiv','local')==1 then opts=opts+' -maxsubdiv '+string(maxsubdiv),end
   if exists('anisomax','local')==1 then opts=opts+' -anisomax '+string(anisomax),end
   if exists('NbSmooth','local')==1 then opts=opts+' -NbSmooth '+string(NbSmooth),end
   if exists('omega','local')==1 then opts=opts+' -omega '+string(omega),end
   if exists('splitpbedge','local')==1 then opts=opts+' -splitpbedge ',end
   if exists('nosplitpbedge','local')==1 then opts=opts+' -nosplitpbedge ',end
   if exists('v','local')==1 then opts=opts+' -v '+string(v),end
   if exists('nbv','local')==1 then opts=opts+' -nbv '+string(nbv),end
   if exists('MaximalAngleOfCorner','local')<>1 then MaximalAngleOfCorner=46; end
   if exists('AngleOfCornerBound','local')<>1 then AngleOfCornerBound=160,end
   
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
   mfprintf(u,'MaximalAngleOfCorner %f\n',MaximalAngleOfCorner);
   mfprintf(u,'AngleOfCornerBound %f\n',AngleOfCornerBound);
   
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
   Arguments=opts +'-g '+bamgf+'.geo -o '+bamgf+'.msh';

   if (getos()=="Windows") then
       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe '+Arguments);
   elseif  (getos()=="Darwin") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin  '+Arguments);
   elseif  (getos()=="Linux") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux  '+Arguments);    
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
