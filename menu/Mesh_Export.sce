SVDIR=pwd();
unix 'mkdir TEMP';
if isdef('th')==%t,
  save(SVDIR+'/temp_var.MESH',th)
  disp(' --- Mesh saved in TMP directory---')
else 
  disp(' --- No Mesh ---')
end


