SVDIR=pwd();
unix 'mkdir TEMP';
if isdef('u')==%t,
  save(SVDIR+'/temp_var.VAR',u)
  disp(' --- Variables saved in TMP directory---')
else 
  disp(' --- No Variables---')
end


