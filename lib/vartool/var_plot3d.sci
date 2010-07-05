function var_plot3d(th,v,rect,grid,scale)
// affichage 3d de variables (hauteur,mapping, ou vecteurs3d)
// th : mesh  possede que 2 ou 3 dimension 
// v : var  (hauteur,mapping, ou vecteurs3d)
//-------------------------------------------------------------
// Syntaxe
// -------
// var_plot3d(th,v)     affichage dans le contexte graphique
// var_plot3d(th,v,grid='on') idem plus maillage
// var_plot3d(th,v,'rect') ou  var_plot(th,v,'iso') affichage iso
// var_plot3d(th,v,rect=[xmin,ymin,zmin,xmax,ymax,zmax]) 
//-------------------------------------------------------------
// Pour l'instant 4 types
// p1 ,p0 ,vecteur2d au noeud, vecteur2d aux faces

// Note
// le traitement de 'rect' et distinctint de hauteur
// et celui du mapping

// echange de bon procede
if typeof(th)=='var' & typeof(v)=='mesh'
  tmp=th; th=v; v=tmp; clear tmp
end
//----- Affichage iso Maillage 3d
if dim(th)==3
  if exists('rect','local')
    if (rect=='rect')|type(rect)==1
      flag=[1,1,4]
      if type(rect)==10
	rect=size(th,'rect')
      end
      ebox=rect([1 4 2 5 3 6]);
    elseif rect=='iso'
      flag=[1,5,4];
      rect=size(th,'rect')
      ebox=rect([1 4 2 5 3 6]);
    end
  end
end
  // ----------------------------------------------------
[n,e,f]=dim(v);
coulmax=256;
xset("colormap",rgbcolor(coulmax))
th.Tri=th.Tri(:,[1 3 2]); // retablir le sens directe
// ------------ Debut du choix des variables-----------
// ------------      Variable p1    -------------------
// ------------  hauteur ou mapping  -------------------
if v.type=='p1'
  // ----- Calcul des couleurs
  coul=matrix(full(v.Node(th.Tri)),-1,3)';
  mi=min(v.Node); ma=max(v.Node);
  if mi~=ma
    coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
  else
    coul=round(coulmax/2)*ones(coul(1,:));
  end
 
  // ----- la variable fait la hauteur
  if dim(th)==2  
    [xx,yy]=th(tri=['x' 'y']);
    zz=matrix(full(v.Node(th.Tri)),-1,3)';
    // Option rect
    if exists('rect','local')
      if (rect=='rect')|type(rect)==1
	if type(rect)==10
	  rect=size(th,'rect')
	  rect=[rect(1:2) min(v.Node) rect(3:4) max(v.Node)]
	end
	flag=[1,1,4];
	ebox=rect([1 4 2 5 3 6]);
      elseif rect=='iso'
	rect=size(th,'rect')
	rect=[rect(1:2) min(v.Node) rect(3:4) max(v.Node)]
	flag=[1,5,4];
	ebox=rect([1 4 2 5 3 6]);
      end
      plot3d(xx,yy,list(zz,coul),flag=flag,ebox=ebox);
    else
      plot3d(xx,yy,list(zz,coul),flag=[0 0 0]);
    end
    if exists('grid','local')
      if grid=='on'
	old=xget('hidden3d');
	xset('hidden3d',0);
	plot3d(xx,yy,zz,flag=[0 0 0]);
	xset('hidden3d',4);
      end
    end
    // la variable correspond a un 'mapping' 
  elseif  dim(th)==3
    [xx,yy,zz]=th(tri=['x' 'y' 'z']);
    coul=matrix(full(v.Node(th.Tri)),-1,3)';
    mi=min(v.Node); ma=max(v.Node);
    if mi~=ma
      coul=round(coulmax*(coul-mi)/(ma-mi))+2;
    else
      [nv,nt]=size(th);
      coul=round(coulmax/2)*ones(nt,1)
    end
    if exists('rect','local')
      plot3d(xx,yy,list(zz,coul),flag=flag,ebox=ebox);
    else
      plot3d(xx,yy,list(zz,coul),flag=[0 0 0]);
    end
    if exists('grid','local')
      if grid=='on'
	old=xget('hidden3d');
	xset('hidden3d',0);
	plot3d(xx,yy,zz,flag=[0 0 0]);
	xset('hidden3d',old);
      end
    end
  end
  
  // ---------       Type vecteur 3D  par noeuds      --------------

elseif and([n,e,f]==[3 0 0])
  if ~exists('scale','local')
    scale=1;
  end
  [np,nt]=size(th);
  bar=th.Coor;
  blak=addcolor([0 0 0]);
  gris=addcolor(0.5*[1 1 1]);
  xx=bar+0.9*scale*full(v.Node);
  if exists('rect','local')
    param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
	list([bar(:,3) xx(:,3)]',blak(ones(bar(:,1))')),...
	flag=flag(2:3),ebox=ebox);
  else
    param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
	list([bar(:,3) xx(:,3)]',blak(ones(bar(:,1))')),flag=[0 0])
  end
  //pause
  bar=xx, xx=xx+0.1*scale*full(v.Node);
  xset("thickness",2)
  param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
      list([bar(:,3) xx(:,3)]',gris(ones(bar(:,1))')),flag=[0 0]);
  xset("thickness",1) 
  if exists('grid','local')
    mesh_plot3d(th)
  end
  // ------------      Variable p0    -------------------
  // ------------  hauteur ou mapping  -------------------
elseif v.type=='p0'
  //--- calcul des couleurs

  mi=min(v.Face); ma=max(v.Face);
  if mi~=ma
    coul=round((coulmax-1)*(v.Face-mi)/(ma-mi))+1;
  else
    coul=round(coulmax/2)*ones(v.Face)
  end
  // cas de hauteur
  if dim(th)==2  // la variable fait la hauteur
    [xx,yy]=th(tri=['x' 'y']);
    zz=v.Face(:,[1 1 1])';
    // Option rect
    if exists('rect','local')
      if (rect=='rect')|type(rect)==1
	if type(rect)==10
	  rect=size(th,'rect')
	  rect=[rect(1:2) min(v.Face) rect(3:4) max(v.Face)]
	end
	flag=[1,1,4];
	ebox=rect([1 4 2 5 3 6]);
      elseif rect=='iso'
	rect=size(th,'rect')
	rect=[rect(1:2) min(v.Face) rect(3:4) max(v.Face)]
	flag=[1,5,4];
	ebox=rect([1 4 2 5 3 6]);
      end
      plot3d(xx,yy,list(zz,coul),flag=flag,ebox=ebox);
    else
      plot3d(xx,yy,list(zz,coul),flag=[0 0 0]);
    end
    if exists('grid','local')
      if grid=='on'
	// option inutile
	//plot3d(xx,yy,zz,flag=[0 0 0]);
      end
    end
    // mapping
  elseif  dim(th)==3
    [xx,yy,zz]=th(tri=['x' 'y' 'z']);
    if exists('rect','local')
      plot3d(xx,yy,list(zz,coul),flag=flag,ebox=ebox);
    else
      plot3d(xx,yy,list(zz,coul),flag=[0 0 0]);
    end
    if exists('grid','local')
      if grid=='on'
	plot3d(xx,yy,zz,flag=[0 0 0]);
      end
    end
  end
  //------------------ Vecteurs 3d par faces ----------
elseif  and([n,e,f]==[0 0 3]) //vecteur par faces
  if ~exists('scale','local')
    scale=1;
  end
  if exists('grid','local')
    mesh_plot3d(th)
  end
  [np,nt]=size(th);
  bar=zeros(nt,3)
  for i=1:3
    bar(:,i)=sum(matrix(th.Coor(th.Tri,i),-1,3),'c')/3;
  end
  blak=addcolor([0 0 0]);
  gris=addcolor(0.5*[1 1 1]);
  xx=bar+0.9*scale*v.Face;
  if exists('rect','local')
    param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
	list([bar(:,3) xx(:,3)]',blak(ones(bar(:,1))')),...
	flag=flag(2:3),ebox=ebox);
  else
    param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
	list([bar(:,3) xx(:,3)]',blak(ones(bar(:,1))')),flag=[0 0])
  end
  //pause
  bar=xx, xx=xx+0.1*scale*v.Face;
  xset("thickness",2)
  param3d1([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]', ...
      list([bar(:,3) xx(:,3)]',gris(ones(bar(:,1))')),flag=[0 0]);
  xset("thickness",1) 
else
  error('Unknown type of variable')
end
endfunction
 



  
  
