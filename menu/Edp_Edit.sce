// Copyright (C) 2010 - M. Ndeffo
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

if isdef('pb')==%t
  if bdr==4
    xedp(pb);
  else
    editvar pb.eq
    editvar pb.BndVal
  end
  else
  disp('   --- no variable ---');
end