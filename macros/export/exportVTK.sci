// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportVTK(varargin)
   [lhs,rhs]=argn(0);
   
//------------  preambule ------------

   filename=varargin(1)
   %u=file('open',filename,'unknown')
   fprintf(%u,'# vtk DataFile Version 3.0');
   fprintf(%u,'vtk output');
   fprintf(%u,'ASCII');

//------- recherche de la geometrie --------

    geoconnue=['grid2d' 'grid3d' 'tri2d' 'tri3d' 'quad2d' 'quad3d' 'tet3d' 'hex3d']
    //-- recherhce d'une geometrie specifie
    boogeo=%f
    for i=2:rhs
      if grep(geoconnue,typeof(varargin(i)))~=[]&(~boogeo)
        execstr(typeof(varargin(i))+'_vtk(%u,varargin(i))');
        boogeo=%t
      end
    end
    // sinon on prend celle qui est attache
    if ~boogeo
      //-------- Cas particulier de dcomp3d ------------
      if typeof(varargin(2))=='dcomp3d'
	dcomp3d_vtk(%u,varargin(2))
      else
	%type=typeof(evstr(varargin(2).geo))
	if typeof(varargin(2))=='RT' 
	  execstr(%type+'_vtk(%u,evstr(varargin(2).geo),RT)')
	else
	  execstr(%type+'_vtk(%u,evstr(varargin(2).geo))')
	end
      end
    end


    scalNode=['df2d' 'df3d' 'q1p2d' 'q1p3d'...
            'q1_2d' 'q1_3d' 'p1_2d' 'p1_3d']
    scalCell=['p0_2d' 'p0_3d' 'p1nc3d']
    booscal=%f
    
//-- recherche des champs Node  

    //--------- scalaire -----------
    
    for i=2:rhs
      if grep(scalNode,typeof(varargin(i)))~=[]
	[nv,ddim]=size(varargin(i));
	if ddim==1
	  if ~booscal
	    fprintf(%u,'POINT_DATA '+string(size(varargin(i))));
	    booscal=%t
	  end
	  Node_vtk(%u,varargin(i));
	end
      end
    end
    
    //---------- vecteur ----------
    
    for i=2:rhs
      if grep(scalNode,typeof(varargin(i)))~=[]
	[nv,ddim]=size(varargin(i));
	if ddim~=1
	  if ~booscal
	    fprintf(%u,'POINT_DATA '+string(size(varargin(i))));
	    booscal=%t
	  end
	  VNode_vtk(%u,varargin(i))
	end
      end
    end
    
//-- recherche des champs Cell

    booscal=%f
    
    //--------- scalaire -----------
    
    for i=2:rhs
      if grep(scalCell,typeof(varargin(i)))~=[]
	[nv,ddim]=size(varargin(i));
	if ddim==1
	  if ~booscal
	    nc=size(evstr(varargin(i).geo),'c');
	    fprintf(%u,'CELL_DATA '+string(nc));
	    booscal=%t
	  end
	  Cell_vtk(%u,varargin(i));
	end
      end       
    end
    
     //---------- vecteur ----------
     
     for i=2:rhs
       if grep(scalCell,typeof(varargin(i)))~=[]
	 [nv,ddim]=size(varargin(i));
	 if ddim~=1
	   if ~booscal
	     nc=size(evstr(varargin(i).geo),'c');
	     fprintf(%u,'CELL_DATA '+string(nc));
	     booscal=%t
	   end
	   VCell_vtk(%u,varargin(i));
	 end
       end  
     end
    
    
    //---------- Cas spécial RT ----------
    
    for i=2:rhs
      if typeof(varargin(i))=='RT'
	[nv,ddim]=size(varargin(i));
	if ddim==1
	  if ~booscal
	    nc=size(evstr(varargin(i).geo),'c');
	    fprintf(%u,'CELL_DATA '+string(nc));
	    booscal=%t
	  end
	  CellRT_vtk(%u,varargin(i));
	end
      end      
    end
     
    
//---------------- cloture ---------------      

   file('close',%u);

  
endfunction









