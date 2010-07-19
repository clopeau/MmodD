SVDIR=uiputfile(["*.MESH*","MESH files"]);
if isdef('th')==%t,
  save(SVDIR,th)
  disp(' --- Mesh saved in TMP directory---')
else 
  disp(' --- No Mesh ---')
end


