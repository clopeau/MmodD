// ====================================================================
// Allan CORNET
// DIGITEO 2009
// This file is released into the public domain
// ====================================================================
libpath = get_absolute_file_path('cleanmacros.sce');
listfic=listfiles(libpath);
dir=[];
for i=1:length(length(listfic,1))
  rep=listfic(i,1)
  if(isdir(libpath+rep))
    dir($+1)=rep;
  end
end

for i=1:size(dir,1)
  binfiles = ls(libpath+dir(i)+'/*.bin');
  for j = 1:size(binfiles,'*')
    mdelete(binfiles(j));
  end

  mdelete(libpath+dir(i)+'/names');
  mdelete(libpath+dir(i)+'/lib');
end
// ====================================================================
