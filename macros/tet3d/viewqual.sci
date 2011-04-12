// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function v=prod_vect(v1,v2)
v=zeros(v1);
v(:,1)=v1(:,2).*v2(:,3)-v1(:,3).*v2(:,2);
v(:,2)=v1(:,3).*v2(:,1)-v1(:,1).*v2(:,3);
v(:,3)=v1(:,1).*v2(:,2)-v1(:,2).*v2(:,1);
endfunction

function viewqual(th,opt)

  rhs=argn(2)
  
  Dom=p0(th,'th.TetId');
  Dom.Id='Domaine'
  Vol=p0(th)
  Vol.Id='Volume_log'
  if th.Det==[]
    Vol.Cell=(abs(det(th)/6));
    [np,n]=size(th)
    %ss=det(th)<0;
    if or(%ss)
      th.Tet(%ss,[3 4])=th.Tet(%ss,[4 3]);
    end
  else
    Vol.Cell=(abs(th.Det)/6);
    np=th.size(1);
    n=th.size(2);
    %ss=th.Det<0;
    if or(%ss)
      th.Tet(%ss,[3 4])=th.Tet(%ss,[4 3]);
    end
  end
  p1=th.Coor(th.Tet(:,1),:);
  p2=th.Coor(th.Tet(:,2),:);
  p3=th.Coor(th.Tet(:,3),:);
  p4=th.Coor(th.Tet(:,4),:);

  Aire=zeros(th.Tet);
  Norm1=prod_vect(p3-p1,p2-p1);
  eucl=sqrt(sum(Norm1.^2,'c'));
  Norm1=Norm1./eucl(:,[1 1 1]);
  Aire(:,1)=eucl/2;
  
  Norm2=prod_vect(p2-p1,p4-p1);
  eucl=sqrt(sum(Norm2.^2,'c'));
  Norm2=Norm2./eucl(:,[1 1 1]);
  Aire(:,2)=eucl/2;

  Norm3=prod_vect(p4-p1,p3-p1);
  eucl=sqrt(sum(Norm3.^2,'c'));
  Norm3=Norm3./eucl(:,[1 1 1]);
  Aire(:,3)=eucl/2;

  Norm4=prod_vect(p3-p2,p4-p2);
  eucl=sqrt(sum(Norm4.^2,'c'));
  Norm4=Norm4./eucl(:,[1 1 1]);
  Aire(:,4)=eucl/2;
  
  clear eucl
  
  // longueurs d'aretes
  Long=zeros(n,6);
  Long(:,1)=sqrt(sum((p2-p1).^2,'c'));
  Long(:,2)=sqrt(sum((p3-p1).^2,'c'));
  Long(:,3)=sqrt(sum((p3-p2).^2,'c'));
  Long(:,4)=sqrt(sum((p4-p1).^2,'c'));
  Long(:,5)=sqrt(sum((p4-p2).^2,'c'));
  Long(:,6)=sqrt(sum((p4-p3).^2,'c'));
  
  clear p1 p2 p3 p4

  // angles diedraux (la numerotation suit celle des aretes)
  
  AnglD=zeros(n,6);
  AnglD(:,1)=%pi-acos(sum(Norm1.*Norm2,'c'));
  AnglD(:,2)=%pi-acos(sum(Norm1.*Norm3,'c'));
  AnglD(:,3)=%pi-acos(sum(Norm1.*Norm4,'c'));
  AnglD(:,4)=%pi-acos(sum(Norm2.*Norm3,'c'));
  AnglD(:,5)=%pi-acos(sum(Norm2.*Norm4,'c'));
  AnglD(:,6)=%pi-acos(sum(Norm3.*Norm4,'c'));

  // angles solides (la numerotation suit celle des sommets)

  AnglS=[ sum(AnglD(:,[1 2 4]),'c')...
	  sum(AnglD(:,[1 3 5]),'c')...
	  sum(AnglD(:,[2 3 6]),'c')...
	  sum(AnglD(:,[4 5 6]),'c')]-%pi;

  clear AnglD
  
  // rayons des spheres inscrites et circonscrites

  Rayon=zeros(n,2);
  
  Rayon(:,1)=3*(Vol.Cell) ./sum(Aire,'c');
  a=prod(Long(:,[1 6]),'c');
  b=prod(Long(:,[2 5]),'c');
  c=prod(Long(:,[3 4]),'c');
  Rayon(:,2)=sqrt((a+b+c).*(a+b-c).*(b+c-a).*(a-b+c))./(24*Vol.Cell);
  
  Qual1=p0(th);Qual1.Id='Min(Sin(AnglS/2))';Qual1.Cell=sin(min(AnglS/2,'c'))*3.674234614174767;
  Qual2=p0(th);Qual2.Id='3Rinsc/Rcirc';Qual2.Cell=3*Rayon(:,1)./Rayon(:,2);
  Qual3=p0(th);Qual3.Id='12(3Vol)^(2/3)/sum(Long^2)';Qual3.Cell=12*(3*Vol.Cell).^(2/3)./sum(Long.^2,'c');
 
  
  //xset('window',0)
  //xset("wdim",800,600)
  xbasc()
  //1er quart
  xsetech([0,0,0.5,0.5]);
  
  if max(Vol)>min(Vol)
    histplot(100,log10(Vol.Cell),normalization=%f);
    xtitle(['Volumes des cellules';'min  '+ msprintf('%1.4E',min(Vol));...
	    'max  '+ msprintf('%1.4E',max(Vol))],'log10',string(size(Vol))...
	+' tetra')
  end
  
    //2eme quart
  xsetech([0.5,0,0.5,0.5]);
  
  if max(Qual1)>min(Qual1)
    histplot(100,Qual1.Cell,normalization=%f);
    xtitle([Qual1.Id;'min  '+string(min(Qual1));...
	    'max  '+string(max(Qual1))],' ',string(size(Qual1))...
	+' tetra')
  end
  
    //3eme quart
  xsetech([0.5,0.5,0.5,0.5]);

  if max(Qual2)>min(Qual2)
    histplot(100,Qual2.Cell,normalization=%f);
    xtitle([Qual2.Id;'min  '+string(min(Qual2));...
	    'max  '+string(max(Qual2))],' ',string(size(Qual2))...
	+' tetra')
  end
  
  xsetech([0,0.5,0.5,0.5]);

  if max(Qual3)>min(Qual3)
    histplot(100,Qual3.Cell,normalization=%f);
    xtitle([Qual3.Id;'min  '+string(min(Qual3));...
	    'max  '+string(max(Qual3))],' ',string(size(Qual3))...
	+' tetra')
  end
  
  if rhs==2
    filename='/tmp/test_'+getenv('LOGNAME')+'.vtk';
    exportVTK(filename,Dom,Vol,Qual1,Qual2,Qual3)
    unix_g("paraview --data="+filename+" &");
  end

  xset("default")
endfunction

