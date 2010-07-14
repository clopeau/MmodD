function [xmn,xmx,ymn,ymx]=RangeSetting(xmn,xmx,ymn,ymx)

while %t
  [ok,xmn,xmx,ymn,ymx]=getvalue('Entrez les nouvelles bornes',..
      ['xmin';'xmax';'ymin';'ymax'],..
      list('vec',1,'vec',1,'vec',1,'vec',1),..
      string([xmn;xmx;ymn;ymx]))
  if ~ok then break,end
  if xmn>xmx|ymn>ymx then
    message('Les bornes sont incorrectes')
  else
    break
  end
end
endfunction    

/////////////////////////////////////////////////:
function th=xmesh()
[lhs,rhs]=argn(0)
gwin=xget("window");
xset('default')
clf()
  Polyg=[];
  Polys=[];
  NbPolys=[];
  PolysBnd=[];
  //exec polycess.sci;
  STOP = 0; // variable me permettant de boucler dessus
  
  //affichage d'une nouvelle fenetre
  //disp('creation d''une nouvelle fenetre') ;
  //gwin = (max(winsid())+1);// genere un nouveau numero de fenetre
  //xset('window',gwin);// affiche la nouvelle fenetre
  clf();
  // nouveaux coordonnees utilisateur
  xsetech([0 0 1 1],[-10 -10 10 10]);

  // ajout des menus de dessins

  // definition du nom du menu
  Nom_de_Menu = 'Dessin';

  // definition des sous-menus
  Sub_Menu    = ['Polyline'];

  // definition du type de fonctions associees au menu Dessin
  ActionPolygone='=[''Polyg=Poly();...
	  if (size(Polyg,1)>0);...
	  Polys=[Polys,Polyg];...
	  PolysBnd=[PolysBnd,2*ones(1:1:size(Polyg,2))];...
	  NbPolys=[NbPolys,size(Polyg,2)];...
	else ;...
      end;'']';
  // definition du vecteur de callback
  execstr(Nom_de_Menu+'_' + string(gwin) + ActionPolygone);
  
  addmenu(gwin,Nom_de_Menu,Sub_Menu,[0,ActionPolygone]);
  
  //Polys=[Polys,Polyg];
  //NbPolys=[NbPolys,size(Polyg,2)];
  // definition du nom du menu
  Nom_de_Menu2 = 'Edition';
  
  // definition des sous-menus
  Sub_Menu2    = ['Edition Points','replot','Edition FRontiere'];
  i=1;
  // definition du type de fonctions associees au menu Dessin
  
  ActionEdition ='=[''[Polys,NbPolys]=edit(Polys,NbPolys)'';''replot(Polys,NbPolys) '';''[PolysBnd,NbPolys]=editBnd(PolysBnd,NbPolys)'']'; 
  
  Nom_de_Menu3 = 'Maillage'
  Sub_Menu3 = ['Maillage du contour'];
  // definition du vecteur de callback
  



  execstr(Nom_de_Menu2+'_' + string(gwin) + ActionEdition);


  addmenu(gwin,Nom_de_Menu2,Sub_Menu2,[0,ActionEdition]);


  Nom_Menu3 = 'Maillage'
  Sub_Menu3 = ['Maillage du contour'];
  ActionMaillage='=[''th=mail(Polys,NbPolys,PolysBnd)'']';
  execstr(Nom_de_Menu3+'_' + string(gwin) + ActionMaillage);
  th=tri2d('x');

  addmenu(gwin,Nom_de_Menu3,Sub_Menu3,[0,ActionMaillage]);
  // menu Setting
  Setting='Setting'
  subStting=['Range';'iso View']
  addmenu(gwin,Setting,subStting)
  execstr(Setting+'_'+string(gwin)+...
      '=[''[xmn,xmx,ymn,ymx]=RangeSetting(xmn,xmx,ymn,ymx);...
	  rect=[xmn,ymn,xmx,ymx];...
	  clf();...
	  plot2d(rect(1),rect(2),-1,strf,'''' '''',rect,axisdata);...
	  xgrid(4)'';...
	  ''strf=''''031'''';clf();...
	  plot2d(rect(1),rect(2),-1,strf,'''' '''',rect,axisdata);...
	  xgrid(4)'']')
  //definition de menu d'arret dans la fenetre graphique
  
  Stop='STOP = 1; delmenu(''Stop''); delmenu(gwin,Nom_de_Menu); delmenu(gwin,''Stop'');delmenu(gwin,Nom_de_Menu2);delmenu(gwin,Nom_de_Menu2)'
  execstr('Stop_' + string(gwin) + '= Stop')
  
  // ajout du menu Stop dans la fenetre graphique
  addmenu(gwin,'Stop');
  // ajout du menu Stop dans la fenetre texte
  //addmenu('Stop')
  
// parametres par default

xmn=0;ymn=0;xmx=1;ymx=1;dx=1;dy=1
axisdata=[2 10 2 10]
strf='011'

	
rect=[xmn,ymn,xmx,ymx];
// menu Exit
//Exit='Exit'
//addmenu(gwin,Exit)
//execstr(Exit+'_'+string(gwin)+'=[''return'']')


plot2d(rect(1),rect(2),-1,'011',' ',rect,axisdata);
xgrid(4)

vide='0';
while (STOP == 0)
  rep=xgetmouse(0)
  x=rep(1)
  if x>0
    x='+'+string(x);
  else
    x=string(x);
  end
  x=x+strcat(vide(ones(length(x):9)));
    
  y=rep(2)
  if y>0
    y='+'+string(y);
  else
    y=string(y);
  end
  y=y+strcat(vide(ones(length(y):9)));
    
  
  xinfo(' clik ('+x+', '+y+')')

end
xdel(gwin)

endfunction
