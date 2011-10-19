tmp=lines();
lines(0)
continuer=%t
stacksize('max')

while continuer
  n=x_choose(['test 2d' ; 'test 3d'],...
      ['Choisir la dimension d''espace'],...
      'Terminer')
  if n==0, return ,end
  dim=n+1;
  ext=string(dim)+'d';
  
  vtype=['p1_']+ext
  
  if ext=='2d'
    grille=['square2d'];
  else
    grille=['tcube3d'];
  end

  
  if ext=='2d'
    lprob=['Laplacien et Conditions de Dirichlet homogene'
	'Laplacien et Conditions de Dirichlet non-homogene'
	'Laplacien et Conditions de Neuman nonhomogene Est'
	'Laplacien et Conditions de Neuman nonhomogene Ouest'
	'Laplacien et Conditions de Neuman nonhomogene Nord'
	'Laplacien et Conditions de Neuman nonhomogene Sud'
	'Laplacien et diffusion en x+, Dirichlet homogene'
	'Laplacien et diffusion en y+, Dirichlet homogene']
    
  else  
    lprob=['Laplacien et Conditions de Dirichlet homogene'
	'Laplacien et Conditions de Dirichlet non-homogene'
	'Laplacien et Conditions de Neuman nonhomogene Est'
	'Laplacien et Conditions de Neuman nonhomogene Ouest'
	'Laplacien et Conditions de Neuman nonhomogene Nord'
	'Laplacien et Conditions de Neuman nonhomogene Sud'
	'Laplacien et Conditions de Neuman nonhomogene Bas'
	'Laplacien et Conditions de Neuman nonhomogene Haut'
	'Laplacien et diffusion en x+, Dirichlet homogene'
	'Laplacien et diffusion en y+, Dirichlet homogene'
	'Laplacien et diffusion en z+, Dirichlet homogene']
  end    
    
  np=x_choose(lprob,['Choisir le problème'],'Terminer')
  if np==0, return ,end
  probl='pb'+ext+'_'+string(np)+'.sce';
  
  if ext=='2d' 
    val=[20;60;100;200;400;700]
  else
    val=[10;15;20;25;35;50]
  end
  val=evstr(x_dialog('entrer les nombre de pas d''espace',...
      '['+strcat(string(val),',')+']'))
  val=val';
  t_mesh=zeros(val)
  t_elementinit=zeros(val)
  t_assemble=zeros(val)
  t_solve=zeros(val)
  err=zeros(val)
  
  for i=1:length(val)
    n=val(i);
    // Ecriture du probleme
    timer();
    if ext=='2d'
      g=evstr(grille+'(n,n+1)');
    else
      g=evstr(grille+'(n,n+1,n+2)');
    end
    t_mesh(i)=timer();
    write(%io(2),'Mesh Time        = '+string(t_mesh(i)))
    u=evstr(vtype+'(g)');
    exec(probl);
    
    if i==1, disp(pb); ,end
    

    write(%io(2),'-------  n = '+string(n)+' --------')
 
    t_elementinit(i)=timer();
    write(%io(2),'Init pde Time    = '+string(t_elementinit(i)))    
    u_ex=evstr(vtype+'(g,'''+sexacte+''')');
    timer();
    
    // assemblage du pb
    [txt,tps]=assemble(pb)
    t_assemble(i)=tps;
    write(%io(2),'Assembling Time  = '+string(tps));
    // resolution du probleme
    [txt,tps]=lsolve(pb);
    t_solve(i)=tps;
    write(%io(2),'Resolution Time  = '+string(tps));
    err(i)=max(abs(u-u_ex))
    write(%io(2),'L_infty error    = '+string(err(i)));
    
  end
  xset('window',0)
  xset("wdim",800,600) 
  clf()
  //1er quart
  xsetech([0,0,0.5,0.5]);
  txt=['pde          :   '+name_mmodd(pb);
      'geometrie    :   '+pb.geo+'   ('+evstr('typeof('+pb.geo+')')+')';
      'variable      :   '+pb.var+'   ('+evstr('typeof('+pb.var+')')+')';
      'equation      :   '+pb.eq]
  for i=1:size(g.BndId,'*')
    txt=[txt;' - frontiere '+g.BndId(i)+' : '+pb.BndVal(i)]
  end
  
  titlepage(txt)
  //2eme quart
  xsetech([0.5,0,0.5,0.5]);
  plot2d("ll",val^(dim),max([t_mesh,t_elementinit,t_assemble,t_solve],0.00001));
  plot2d("ll",val^(dim),max([t_mesh,t_elementinit,t_assemble,t_solve],0.00001),-4:-1,strf="000");
  legends(['Mesh Time','Init pde time','Assembling Time','Resolution Time'],-4:-1,4);
  xtitle('Execution Time',['nb of freedom'],'time (s)')
  
  //3eme quart
  xsetech([0.5,0.5,0.5,0.5]); 
  if ext=='2d'
    txt=['Calculs effectuées sur une grille';
	'cartésienne de taille nxn';
	'n='+strcat(string(val),',')]
  else
    txt=['Calculs effectuées sur une grille cartésienne';
	'de taille nxnxn';
	'n = '+strcat(string(val),',')]
  end
  
  execstr(typeof(evstr(pb.var))+'_plot3d('+pb.var+')');
  
  //titlepage(txt)
  //dernier
  xsetech([0,0.5,0.5,0.5]);
  plot2d("ll",val^(dim),err);
  plot2d("ll",val^(dim),err,-1,strf="000");
  xtitle('errors',['nb of freedom'],'error')
  
  
  //xset("default")
end

