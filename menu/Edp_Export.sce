SVDIR=pwd();
unix 'mkdir TEMP';
if isdef('pb')==%t,
  save(SVDIR+'/temp_var.EDP',pb)
  disp(' --- Equation definition saved in TMP directory---')
else 
  disp(' --- No Edp---')
end
