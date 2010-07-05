function exportGMV(varargin)
   [lhs,rhs]=argn(0);
//-- preambule
   filename=varargin(1)
   u=file('open',filename,'unknown')
   fprintf(u,'gmvinput ascii');
   fprintf(u,'comments')
   fprintf(u,'   comments before nodes')
   fprintf(u,'endcomm')
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
	  fprintf(u,'variable')// ouverture du type variable
	  booscal=%t
	end
	Node_gmv(u,varargin(i));
      end
    end
    if booscal
      fprintf(u,'endvars'); // fermeture des var
    end
  
  
//--- cloture   
   fprintf(u,'endgmv');
   file('close',u);

endfunction

