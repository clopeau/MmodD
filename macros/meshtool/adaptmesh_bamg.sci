// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [th,txt]=adaptmesh_bamg(th,uin,hmax)
// fonction d'interface avec bamg
   [lhs,rhs]=argn(0)
   
   bamgf=th.Id
   
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
   mfprintf(u,'2 1 %i 2\n',size(uin))
   mfprintf(u,'%3.12f\n',uin.Node);
   
   mclose(u);
   //-------------------------- Execution Bamg --------------------
   // processing bamg
   Arguments='-r '+bamgf+'  -Mbb '+bamgf+'.bb  -oM '+bamgf+'.M';
   
   if (getos()=="Windows") then
       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe '+Arguments);
   elseif  (getos()=="Darwin") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin ' +Arguments);
   elseif  (getos()=="Linux") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux '  +Arguments);   
   end
   
   Arguments=' -splitpbedge -noKeepBackVertices -maxsubdiv 5 -hmax 2 -hmin 0.0000005 -raison 2.5  -v 4 -err 0.005 -errg 0.01 '+..
   '-r '+bamgf+'  -M '+bamgf+'.M  -o '+bamgf+'.1.msh';
   
   if (getos()=="Windows") then
       txt=unix_g(mmodd_getpath()+'\thirdparty\bamg.Win.exe '+Arguments);
   elseif  (getos()=="Darwin") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.darwin ' +Arguments);
   elseif  (getos()=="Linux") then 
       txt=unix_g(mmodd_getpath()+'/thirdparty/bamg.linux '  +Arguments);   
   end
   
   
   
   write(%io(2),txt);
   if (grep(txt,'Error')~=[]) | (txt==[])
     write(%io(2),txt)
     error('bamg process error')
     return
   end

   //------------------------- Lecure des donnees ------------------
   bamgf=bamgf+'.1';
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
   

   bamg_geo_file=th.bamg_geo_file;
   th=read_tri2d_BAMG(bamgf+'.msh')
   tmp=getfield(1,th);
   if grep(tmp,'bamg_geo_file')==[] then
          setfield(1,[tmp;'bamg_geo_file'],th)
   end
   th.bamg_geo_file=bamg_geo_file;
   //unix('rm '+bamgf+'*');

endfunction
