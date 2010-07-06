//function DupliqueVar(repin,repout,varout)

// à partir du q1p2d  pas touch !!!
ref='grid2d'
repin='lib/grid2d/';

//for varout=['p1_2d' 'p1_3d' 'q1_2d' 'q1_3d' 'q1p3d' 'df2d' 'df3d']
for varout=['grid1d']
  // Nouvelle Sortie

  repout='lib/'+varout+'/';


  //fichierin=unix_g('ls '+repin+' | grep q1p2d');
  fichierin=unix_g('ls '+repin);
  for i=['x_q1p2d.sci' 'y_q1p2d.sci' 'Dn_q1p2d.sci'...
	  'Id_q1p2d.sci' 'Laplace_q1p2d.sci' 'Grad_q1p2d.sci']
    rang=grep(fichierin,i)
    fichierin(rang)=[];
  end
  fichierout=strsubst(fichierin,ref,varout);
  
  for i=1:size(fichierout,'*')
    i
    fd=mopen(repin + fichierin(i),'r')
    txt=mgetl(fd,-1);
    mclose(fd)
    
    txt=strsubst(txt,ref,varout);
    // changement de type
    //txt=strsubst(txt,'Node','Face');
    
    fd=mopen(repout + fichierout(i),'w+')
    txt=mputl(txt,fd)
    mclose(fd)
  end
end

