SVDIR=uiputfile(["*.VAR","VAR files"]);

if isdef('u')==%t,
  save(SVDIR,u)
  disp(' --- Variables saved in TMP directory---')
else 
  disp(' --- No Variables---')
end


