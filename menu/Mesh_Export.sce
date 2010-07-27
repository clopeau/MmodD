// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

SVDIR=uiputfile(["*.MESH*","MESH files"]);
if length(SVDIR)>0
  if isdef('th')==%t,
    //étape intermédiaire permettant d'éviter de rajouter un .Mesh si le fichier est déjà un .mesh
    Lecture=strsplit(SVDIR);
    if strcat(Lecture($-4:$))=='.MESH',save(SVDIR,th)
    else
  save(SVDIR+'.MESH',th)
     end
 disp(' --- Mesh saved in path: '+SVDIR)     
else 
  disp(' --- No Mesh Saved ---')
  end
  else disp(' --- No Mesh Saved ---');

end


