// Copyright (C) 2010 - M. Ndeffo
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

SVDIR=uigetfile('*.EDP');
if isdef('pb')==%t,
load(SVDIR,'pb')
  disp(' --- Equation definition loaded --- ');
else 
  disp(' --- No Edp---');
end