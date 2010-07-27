// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

if isdef('u')==%t
  editvar u.Id;
  disp( ' --- please to confirm your choice in editor by pressing Enter then update and quit ---');
else
  disp('   --- no variable ---');
end