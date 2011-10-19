lines(0)
continuer=%t
stacksize('max')

while continuer
  n=x_choose(['test 2d' ; 'test 3d'],...
      ['Choisir la dimension d''espace'],...
      'Terminer')
  if n==0, return ,end
  ext=string(n+1)+'d';
  
  vtype=['p1_']+ext
  
  if ext=='2d'
    grille=['square2d'];
  else
    grille=['tcube3d'];
  end

//  nv=4
//  while nv>3
//    nv=x_choose(vtype,['Choisir le type de variable'],'Terminer')
//  end

//  vtype=vtype(nv);
//  grille=grille(nv);
  
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
    val=[20;60;100;200]
  else
    val=[10;15;20;25]
  end
  val=evstr(x_dialog('entrer les nombre de pas d''espace',...
      '['+strcat(string(val),',')+']'))
  val=val';
  t_pde=zeros(val)
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
    u=evstr(vtype+'(g)');
    exec(probl);
    
    if i==1, disp(pb); ,end
    

    write(%io(2),'-------  n = '+string(n)+' --------')
 
    t_pde(i)=timer();
    u_ex=evstr(vtype+'(g,'''+sexacte+''')');
    write(%io(2),'Temps mail = '+string(t_pde(i)))
    
    // assemblage du pb
    [txt,tps]=assemble(pb)
    t_assemble(i)=tps;
    write(%io(2),'Temps ass  = '+string(tps));
    // resolution du probleme
    [txt,tps]=lsolve(pb);
    t_solve(i)=tps;
    write(%io(2),'Temps sol  = '+string(tps));
    err(i)=max(abs(u-u_ex))
    write(%io(2),'  Erreur   = '+string(err(i)));
    
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
  plot2d("ll",val(:,ones(1:3)),max([t_pde,t_assemble,t_solve],0.01));
  plot2d("ll",val(:,ones(1:3)),max([t_pde,t_assemble,t_solve],0.01),-3:-1,strf="000");
  legends(['temps ecriture pde','temps assemblage','temps resolution'],1:3,4);
  xtitle('Courbes des temps d''execution',['points par';'coté de grille'],'temps')
  
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
  
  titlepage(txt)
  //dernier
  xsetech([0,0.5,0.5,0.5]);
  plot2d("ll",val,err);
  plot2d("ll",val,err,-1,strf="000");
  xtitle('Courbes des erreurs',['points par';'coté de grille'],'erreur')
  
  
  //xset("default")
end
