// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [th,txt]=adaptmesh_bamg(th,sol,coef,ratio,hmax,hmin,errg,err,ratio,iso,aniso,RelErro,AbsError,Rescalin,NoRescaling,CutOff,power,NbJacobi,maxsubdiv,anisomax,NbSmooth,omega,splitpbedge,nosplitpbedge,v,nbv)
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
   if exists('iso','local')==1 then opts=opts+' -iso',end
   if exists('aniso','local')==1 then opts=opts+' -aniso',end
   if exists('RelError','local')==1 then opts=opts+' -RelError',end
   if exists('AbsError','local')==1 then opts=opts+' -AbsError',end
   if exists('Rescaling','local')==1 then opts=opts+' -Rescaling',end
   if exists('NoRescaling','local')==1 then opts=opts+' -NoRescaling',end
   if exists('CutOff','local')==1 then opts=opts+' -CutOff '+string(CutOff),end
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
   
   // work on the file name
   bamgf=th.Id
   nbf=length(bamgf)
   if part(th.Id,nbf-2:nbf)=='msh' then
       bamgf=part(bamgf,1:nbf-4)
   end
   
   varargin=list(sol)
   nb_sol=0;
   sol_index=[]
   for i=1:length(varargin)
       if typeof(varargin(i))=="p1_2d" then
           nb_sol=nb_sol+1;
           sol_index=[sol_index,i]
       end
   end
   if nb_sol==0 then
       error('adaptmesh_bamg must have at least one solution on the mesh to process')
   end

   list_open_file=file()
   ierr=execstr("u=mopen("""+bamgf+".bb"",""wt"")",'errcatch')
   if ierr<>0
       [str,n]=lasterror()
       if length(list_open_file)<length(file()) then
           [tmp,k]=intersect(list_open_file,file());
           list_open_file(k)=[];
           mclose(list_open_file)
       end
       error(str,n)
   end
   mfprintf(u,'2 %i %i 2\n',nb_sol,size(varargin(sol_index(1))))
   for i=1:nb_sol
       mfprintf(u,'%3.12f\n',varargin(sol_index(1)).Node);
   end
   mclose(u);

   //-------------------------- Execution Bamg --------------------
   // processing bamg
   ind=strindex(bamgf,'.')
   if ind==[] then
       ext='.0'
       newbamgf=bamgf+ext
   else
       ext=part(bamgf,ind($)+1:length(bamgf))
       ext=string(evstr(ext)+1)
       newbamgf=part(bamgf,1:ind($))+ext
   end
   Arguments=opts +' -b '+bamgf+'.msh  -Mbb '+bamgf+'.bb  -o '+newbamgf+'.msh';
   disp(Arguments)
   if (getos()=="Windows") then
       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe '+Arguments);
   elseif  (getos()=="Darwin") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin ' +Arguments);
   elseif  (getos()=="Linux") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux '  +Arguments);   
   end
   
//   Arguments=' -splitpbedge -noKeepBackVertices -maxsubdiv 5 -hmax 2 -hmin 0.0000005 -raison 2.5  -v 4 -err 0.005 -errg 0.01 '+..
//   '-r '+bamgf+'  -M '+bamgf+'.M  -o '+bamgf+'.1.msh';
//   
//   if (getos()=="Windows") then
//       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe '+Arguments);
//   elseif  (getos()=="Darwin") then 
//       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin ' +Arguments);
//   elseif  (getos()=="Linux") then 
//       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux '  +Arguments);   
//   end
   
   
   
   write(%io(2),txt);
   if (grep(txt,'Error')~=[]) | (txt==[])
     write(%io(2),txt)
     error('bamg process error')
     return
   end

   //------------------------- Lecure des donnees ------------------
   list_open_file=file()
   ierr=execstr( 'u=file(''open'','''+newbamgf+'.msh'',''unknown'')' ,'errcatch','n'); 
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
   

   bamg_geo_file=th.bamg_geo_file;
   BndId=th.BndId;
   th=read_tri2d_BAMG(newbamgf+'.msh')
   tmp=getfield(1,th);
   if grep(tmp,'bamg_geo_file')==[] then
          setfield(1,[tmp;'bamg_geo_file'],th)
   end
   th.bamg_geo_file=bamg_geo_file;
   if size(th.BndId,2)<>size(BndId,2)
     warnin('adaptmesh_bamg : the number of boundaries is not the"+...
	    " same !')
   else
     th.BndId=BndId
   end
   //unix('rm '+bamgf+'*');

endfunction
