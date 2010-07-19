SVDIR=uigetfile('*.EDP');
if isdef('pb')==%t,
load(SVDIR,'pb')
  disp(' --- Equation definition loaded --- ');
else 
  disp(' --- No Edp---');
end