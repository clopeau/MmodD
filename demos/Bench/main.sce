tmp=lines();
lines(0)
stacksize('max')
demopath = get_absolute_file_path("main.sce")

  n=x_choose(['test 2d' ; 'test 3d'],...
      ['Choose the space dimension'],...
      'Cancel')
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
    lprob=['Laplacien with homogene dirichlet boudary conditions'
	'Laplacien with non-homogene dirichlet boudary conditions'
	'Laplacien with non-homogene Neuman nonhomogene Est'
	'Laplacien with non-homogene Neuman nonhomogene West'
	'Laplacien with non-homogene Neuman nonhomogene Nord'
	'Laplacien with non-homogene Neuman nonhomogene Sud'
	'Laplacien and diffusion in x+, Dirichlet homogene'
	'Laplacien and diffusion in y+, Dirichlet homogene']
    
  else  
    lprob=['Laplacien with homogene dirichlet boudary conditions'
	   'Laplacien with non-homogene dirichlet boudary conditions'
	   'Laplacien with non-homogene Neuman nonhomogene Est'
	   'Laplacien with non-homogene Neuman nonhomogene West'
	   'Laplacien with non-homogene Neuman nonhomogene Nord'
	   'Laplacien with non-homogene Neuman nonhomogene Sud'
	   'Laplacien with non-homogene Neuman nonhomogene Down'
	   'Laplacien with non-homogene Neuman nonhomogene Up'
	   'Laplacien and diffusion in x+, Dirichlet homogene'
	   'Laplacien and diffusion in y+, Dirichlet homogene'
	   'Laplacien and diffusion in z+, Dirichlet homogene']
  end    
    
  np=x_choose(lprob,['Choose the problem'],'Cancel')
  if np==0, return ,end
  probl='pb'+ext+'_'+string(np)+'.sce';
  
  if ext=='2d' 
    val=[20;60;100;200;400;700]
  else
    val=[10;15;20;25;30;35]
  end
  val=evstr(x_dialog('Grid sizes ',...
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
    exec(demopath+probl);
    
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
  //3eme quart
  xsetech([0,0.5,0.5,0.5]);
  txt=['pde        :   '+name_mmodd(pb);
      'geometry   :   '+pb.geo+'   ('+evstr('typeof('+pb.geo+')')+')';
      'variable   :   '+pb.var+'   ('+evstr('typeof('+pb.var+')')+')';
      'equation   :   '; pb.eq]
  for i=1:size(g.BndId,'*')
    txt=[txt;'boundary '+g.BndId(i)+' : '+pb.BndVal(i)]
  end
  
  xstring(0,0,txt)
  //titlepage(txt)
  t=get("hdl")   //get the handle of the newly created object

  t.font_foreground=6;// change font properties
  t.font_size=1;
  t.font_style=0;
  //t.font_style=5;

  //2eme quart
  xsetech([0.5,0,0.5,0.5]);
  plot2d("ll",val^(dim),max([t_mesh,t_elementinit,t_assemble,t_solve],0.00001),[1,80,160,240]);
  plot2d("ll",val^(dim),max([t_mesh,t_elementinit,t_assemble,t_solve],0.00001),-4:-1,strf="000");
  legends(['Mesh Time','Init pde time','Assembling Time','Resolution Time'],-4:-1,4);
  xtitle('Execution Time',['nb of freedom'],'time (s)')
  
  //3eme quart
  xsetech([0.5,0.5,0.5,0.5]); 

  if ext=='2d'
    execstr(typeof(evstr(pb.var))+'_plot3d('+pb.var+')');
  else
    execstr(typeof(evstr(pb.var))+'_slice('+pb.var+',[0.2:0.2:0.8],[],[0.25 0.75],flag=[-2 3 4])');
  end
  //1er quart dernier
  xsetech([0,0,0.5,0.5]);
  
  plot2d("ll",val^(dim),err);
  plot2d("ll",val^(dim),err,-1,strf="000");
  xtitle('errors',['nb of freedom'],'error')
  
  

