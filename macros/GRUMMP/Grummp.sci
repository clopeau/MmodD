function [th] = Grummp(Nomfichier) 
  rep=toolbox_dir;
 if(MSDOS)
  unix( 'del '+Nomfichier+'.mesh')
  unix( rep+'macros/GRUMMP/tri.exe -i ./'+Nomfichier)
 else 
     unix( 'rm '+Nomfichier+'.mesh')
     unix( rep+'macros/GRUMMP/tri -i ./'+Nomfichier)
 end
th=tri2d(Nomfichier)
u=file('open',Nomfichier+'.mesh','unknown');
n=read(u,1,4);
nt=n(1);nf=n(2);nfb=n(3);nv=n(4);
th.Coor=read(u,nv,2)
th.Tri=read(u,nt,3)
file('close',u)
return(th)
endfunction
