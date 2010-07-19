////  delmenu('Fichier')
////  delmenu('Outils')
////  delmenu('Edition')
////  delmenu('Mesh')
////  delmenu('Plot')
////  delmenu('Var')
//  
//  // nouvelle fenetre
//  gwin=(max(winsid())+1);
//  xset('window',gwin);
//   xset("wdim",800,600)
//  gwin=xget("window");
//  // Menu deja existant par defaut  
//  delmenu(gwin,'Edition') 
//  delmenu(gwin,'?')
//  delmenu(gwin,'Fichier')
//  delmenu(gwin,'Outils')
// // function [] = menu(gwin)
//  f=gcf();
//  //ui=figure(2)
// 
//  mmesh=uimenu(f,'label', 'Mesh');
//  mplot=uimenu(f,'label','Plot');
//  mvar=uimenu(f,'label','Var');
//  mequ=uimenu(f,'label','Equation','callback','pb=funcallbackequ()');
//  msolv=uimenu(f,'label','Solve Problem','callback','assemble(pb);lsolve(pb)');
//  // create an item on the menu bar
//  mmesh1=uimenu(mmesh,'label', 'New Mesh','callback','th=funcallbackel()' );
//  mvar1=uimenu(mvar,'label','New Var','callback','u=funcallbackvar()')
//  mplot1=uimenu(mplot,'label','Plot Mesh','callback','funcallbackaffMesh()');
//  mplot2=uimenu(mplot,'label','Plot Var','callback','funcallbackaffVar()')
//  
//  //mod=uicontrol(ui,'Style','Pushbutton','String','Mode','Tag','modeaffichage','Units','normalized','position', [1.0 0.80 0.20  0.10],'callback','funcallbackmode(etat)');
//// create a listbox
//  
//   //endfunction
//   
//   function [u] = funcallbackvar()
//   clear u
//   txt = ['associated mesh';'fonction'];
//   sig = x_mdialog('enter parameter of elements',txt,['th';'x+y'])
//   th=evstr(sig(1))
//   func=sig(2)
//   u=p1_2d(th,string(func))
//   return(u)
//   endfunction
//   
//  function [] = funcallbackaffMesh()   
//    f=gcf()
//    clf();
//    mesh_disp(th)  
//  menu()
//  endfunction
//  
//   function [] = funcallbackaffVar()   
//    f=gcf()
//    clf();
//    p1_2d_plot3d(u)
//  menu()
//  endfunction
// 
// function [th] = funcallbackel()
//   clear th
//   txt = ['number node x';'number node y'];
//   sig = x_mdialog('enter parameter of triangulation',txt,['10';'10'])
//   nx=evstr(sig(1))
//   ny=evstr(sig(2))
//   th=square2d(nx,ny)
//   return(th)
// endfunction
// 
//function [pb] = funcallbackequ()
//  pb=edp(u)
//  txt= [ 'A*Laplace(u) ,  A='; 'B*u , B='; 'secmembre=']
//  txt2= [ 'Boundary N =';'Boundary S';'Boundary E';'Boundary W']
//  sig=  x_mdialog('enter parameter of Equation',txt,['1';'1';'1'])
//  pb.eq=sig(1)+'*Laplace(u)'+'+'+sig(2)+'*Id(u)'+'='+sig(3);
//  sig = x_mdialog('enter parameter of Boundary condition',txt2,['0';'0';'0';'0'])
//endfunction
// 
//usecanvas(%T); 
//f=figure();
// // etat d'affichage :voir node, triangles et extremes
//etat=[%f;%f;%f;%t;%t;%f];
// //menu();
//   
//
//
//