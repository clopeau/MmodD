// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function var_plot(th,v,rect,grid,scale,colorbar,z)
// affichage 2d de variables (contour ou vecteur)
// th : mesh ne possede que 2 dimension (autrement utiliser ...3d)
// v  : var
//--------------------------------------------------------------------
// Syntaxe
// var_plot(th,v)     affichage dans le contexte graphique
// var_plot(th,v,grid='on') idem plus maillage
// var_plot(th,v,'rect') ou  var_plot(th,v,'iso') affichage iso ou rect 
//                        NECESSAIREMENT en 2 eme argument
// var_plot(th,v,colorbar='on') colorbar dans fenetre separee
// var_plot(th,v,z=[zmin,zmax]) affiche les contours concernes
//--------------------------------------------------------------------
// Pour l'instant 4 types
// p1 ,p0 ,vecteur2d au noeud, vecteur2d aux faces

// echange de bon procede
if typeof(v)=='mesh'
  tmp=th; th=v; v=tmp; clear tmp
end
// contexte graphique affichage 'iso' ou 'rect'
if exists('rect','local')
  if rect=='rect' 
    rect=size(th,'rect');
    strf="051";
  elseif rect=='iso'
    rect=size(th,'rect')
    strf="031";
  else
    strf="051";
  end
  plot2d(0,0,0,strf=strf,rect=rect);
end
    
// ----------------------------------------------------
[n,e,f]=dim(v);
coulmax=256;
xset("colormap",rgbcolor(coulmax))
// ------------ Debut du choix des variables-----------
// --------------     Type P1     -----------
if v.type=='p1' & dim(v)<2
  if dim(v)==1    // inutile
    [np,nt]=size(th);
    triangl=[(1:nt)'  th.Tri  zeros(nt,1)]
    
    // Cas de zim et zmax precisé
    if exists('z','local')
      zminmax=z
    else
      zminmax=[min(v.Node),max(v.Node)];
    end
    // utilisation de fec
    // Attention pour zminmax
    // les couleurs sont tronque et stoppe a la valeur maximale
    fec(th.Coor(:,1),th.Coor(:,2),triangl,full(v.Node),...
	strf="000",zminmax=zminmax)
    if exists('grid','local')
      if grid=='on'
	mesh_plot(th)
      end
    end
    if exists('colorbar','local')
      xcolorbar(zminmax(1),zminmax(2));
    end
  else 
    error('Bad type of variable')
  end
// ---------       Type vecteur 2D  par noeuds      --------------
elseif and([n,e,f]==[2 0 0])| (v.type=='p1' & dim(v)==2)  //vecteur par noeuds
  if ~exists('scale','local')
    scale=1;
  end
  if exists('grid','local')
    mesh_plot(th);
  end
  xx=th.Coor+scale*full(v.Node);
  xarrows([th.Coor(:,1) xx(:,1)]',[th.Coor(:,2) xx(:,2)]' )

//------ Type P0 -----------
elseif v.type=='p0'
  if dim(v)==1
    
    // zmin et zmax suivant option
    if exists('z','local')
      mi=z(1);
      ma=z(2);
    else
      mi=min(v.Face); ma=max(v.Face);  
    end
    
    if exists('colorbar','local')
      xcolorbar(mi,ma);
    end
    
    if mi~=ma
      coul=int((coulmax-1)*(v.Face-mi)/(ma-mi))+1;
      coul(coul>coulmax)=0;
      coul(coul<1)=0;
    else
      coul=zeros(v.Face);
      coul(v.Face==mi)=int(coulmax/2);
    end
    
    
    xx=th(tri='x');yy=th(tri='y');
    xfpolys(xx,yy,coul);
    if ~exists('grid')
      xpolys([xx ; xx(1,:)],[yy ; yy(1,:)],coul);
    end
  else
    error('Bad type of variable');
  end
//--------- Type vecteur 2d par face -----------------
elseif and([n,e,f]==[0 0 2]) //vecteur par faces
  if ~exists('scale','local')
    scale=1;
  end
  if exists('grid','local')
    mesh_plot(th)
  end
  [np,nt]=size(th);
  bar=zeros(nt,f)
  for i=1:f
    bar(:,i)=sum(matrix(th.Coor(th.Tri,i),-1,3),'c')/3;
  end
  xx=bar+scale*v.Face;
  xarrows([bar(:,1) xx(:,1)]',[bar(:,2) xx(:,2)]' )

//-------- Type inconnu ------------
else
  error('Unknown type of variable')
end

endfunction




  
  
