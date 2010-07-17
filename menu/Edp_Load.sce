SVDIR=pwd();
if isdef('pb')==%t,
load(SVDIR+'/temp_var.EDP','pb')
  disp(' --- Equation definition loaded --- ');
else 
  disp(' --- No Edp---');
end