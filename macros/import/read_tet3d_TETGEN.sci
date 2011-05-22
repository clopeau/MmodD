// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tet3d_TETGEN(nombase)
    // the nombas is without the extension (multiple file)
    // files:
    //         nombase.node (nodes)
    //                .ele (tetrahedron)
    //------------- To do ----------------
    //                .face (face triangles)
    //
    th=tet3d(nombase)
    u=file('open',nombase+'.node','unknown')
    n='#'
    while grep(n,'#')~=[]
      n=read(u,1,1,'(a)');
    end
    n=evstr('['+n+']');
    nbpoint=n(1);
    if n(2)~=3
      write(%io(2),'Bad input Format From TETGEN')
      file('close',u);
      return
    end
    Node=read(u,nbpoint,4+n(3))
    file('close',u);
    
    th.Coor=Node(:,2:4);
    clear Node
    
    u=file('open',nombase+'.ele','unknown')
    n='#'
    while grep(n,'#')~=[]
       n=read(u,1,1,'(a)');
    end
    n=evstr('['+n+']');
    
    nbtet=n(1);
    Tet=read(u,nbtet,5+n(3))
    file('close',u);
    
    th.Tet=gsort(Tet(:,2:5),'c','i');
    if n(3)>0
      th.TetId=Tet(:,6);
    else
      th.TetId=ones(Tet(:,5));
    end
    clear Tet
    
    u=file('open',nombase+'.face','unknown')
    n='#'
    while grep(n,'#')~=[]
       n=read(u,1,1,'(a)');
    end
    n=evstr('['+n+']');
    nbface=n(1)
    Face=read(u,nbface,4+n(2))
    file('close',u);

    th.Tri=Face(:,2:4);
    
    if n(2)>0
      th.TriId=Face(:,5)
    else
      th.TriId=zeros(Face(:,4))
    end
        
    if n(2)==0
      th.Bnd=Face(:,2:4);
      th.BndId="f1";
    else
      ind=0
      for i=unique(Face(:,4+n(2)))'
	if i~=0
	  ind=ind+1;
	  bitri=Face(:,5)==i;
	  th.Bnd(ind)=Face(bitri,2:4);
	  th.BndiTri(ind)=find(bitri)';
	  th.BndId=[th.BndId 'f'+string(i)];
	end
      end
    end
    clear Face
    
    th.Det=det(th);
    th.size=[size(th.Coor,1),size(th.Tet,1),size(th.Tri,1)]
    
endfunction
  
    
