SVDIR=uiputfile(["*.EDP","EPD files"]);
unix 'mkdir TEMP';
if isdef('pb')==%t,
  save(SVDIR,pb)
  disp(' --- Equation definition saved in TMP directory---')
else 
  disp(' --- No Edp---')
end
