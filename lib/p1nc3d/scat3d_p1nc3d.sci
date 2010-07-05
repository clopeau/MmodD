function out=scat3d_p1nc3d(%u,%th)

 basename='/tmp/test_'+getenv('LOGNAME');
 // ecriture du fichier des noeuds des centres des faces
  
  u=file('open',basename+'.data','unknown')
  
  X=x_tet3d_Face(evstr(%u.geo));
  Y=y_tet3d_Face(evstr(%u.geo));
  Z=z_tet3d_Face(evstr(%u.geo));
  ndata=size(%u.Face,2);
  fprintf(u,'%i %i\n',length(X),ndata);
  str="";
  for i=1:ndata
    str=str+" %3.15f";
  end
  fprintf(u,'%3.15f %3.15f %3.15f'+str+'\n',X,Y,Z,%u.Face);
  
  file('close',u);
  
  u=file('open',basename+'.points','unknown')
  
  X=x_tet3d_Face(%th);
  Y=y_tet3d_Face(%th);
  Z=z_tet3d_Face(%th);
  fprintf(u,'%i\n',length(X));
  fprintf(u,'%3.15f %3.15f %3.15f\n',X,Y,Z);
 
  file('close',u);
  
  unix_g("scat3d -i "+basename);
  
  u=file('open',basename+'.out','unknown')
  tmp=read(u,-1,3+ndata)
  file('close',u);
  
  out=p1nc3d(%th);
  out.Id=%u.Id;
  //out.geo=names(%th);
  out.Face=tmp(:,4:3+ndata); 
  
endfunction

