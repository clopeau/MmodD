ref='q1p2d';
repin='lib/visualisation/';
repout=repin;

fd=mopen(repin +'q1p2d_gmv.sci','r')
txt=mgetl(fd,-1);
mclose(fd)

for varout=['p1_2d' 'p1_3d' 'q1_2d' 'q1_3d' 'q1p3d' 'df2d' 'df3d']

  fichierout=varout+'_gmv.sci';

  fd=mopen(repout + fichierout,'w+')
  mputl(strsubst(txt,ref,varout),fd)

  mclose(fd)
end


