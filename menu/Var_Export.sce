// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

SVDIR=uiputfile(["*.EDP*","EDP files"]);
if length(SVDIR)>0
  if isdef('pb')==%t,
    //étape intermédiaire permettant d'éviter de rajouter un .Mesh si le fichier est déjà un .var
    Lecture=strsplit(SVDIR);
    if strcat(Lecture($-4:$))=='.EDP',save(SVDIR,th)
    else
  save(SVDIR+'.EDP',th)
     end
 disp(' --- Equation definition saved in path: '+SVDIR)     
else 
  disp(' --- No Edp Saved ---')
  end
  else disp(' --- No Edp Saved ---');

end
