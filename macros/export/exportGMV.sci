// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportGMV(varargin)
   [lhs,rhs]=argn(0);
//-- preambule
   filename=varargin(1)
   u=mopen(filename,'wt')
   mfprintf(u,'gmvinput ascii\n');
   mfprintf(u,'comments\n')
   mfprintf(u,'   comments before nodes\n')
   mfprintf(u,'endcomm\n')
//-- recherche de la geometrie
    geoconnue=['grid2d' 'grid3d' 'tri2d' 'quad2d' 'tet3d' 'hex3d']
    //-- recherhce d'une geometrie specifie
    boogeo=%f
    for i=2:rhs
      if grep(geoconnue,typeof(varargin(i)))~=[]&(~boogeo)
	execstr(typeof(varargin(i))+'_gmv(u,varargin(i))');
	boogeo=%t
      end
    end
    // sinon on prend celle qui est attaché
    if ~boogeo
      t=typeof(evstr(varargin(2).geo))
      execstr(t+'_gmv(u,evstr(varargin(2).geo))')
    end

//-- recherche des vecteurs  
    for i=2:rhs
      [nv,ddim]=size(varargin(i));
      if ddim~=1
	vector_gmv(u,varargin(i))
      end
    end
   
//-- recherche des champs scalaires  
    scalconnu=['df2d' 'df3d' 'q1p2d' 'q1p3d'...
	    'q1_2d' 'q1_3d' 'p1_2d' 'p1_3d']
    booscal=%f
    for i=2:rhs
      [nv,ddim]=size(varargin(i));
      if ddim==1
	if ~booscal
	  mfprintf(u,'variable\n')// ouverture du type variable
	  booscal=%t
	end
	Node_gmv(u,varargin(i));
      end
    end
    if booscal
      mfprintf(u,'endvars\n'); // fermeture des var
    end
  
  
//--- cloture   
   mfprintf(u,'endgmv\n');
   mclose(u);

endfunction

